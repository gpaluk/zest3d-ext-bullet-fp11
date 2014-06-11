package zest3d.ext.bullet.dynamics 
{
	import AWPC_Run.CModule;
	import AWPC_Run.createBodyInC;
	import AWPC_Run.setBodyMassInC;
	import io.plugin.math.algebra.AVector;
	import io.plugin.math.algebra.HMatrix;
	import zest3d.ext.bullet.collision.dispatch.BulletCollisionObject;
	import zest3d.ext.bullet.collision.shapes.BulletCollisionShape;
	import zest3d.ext.bullet.math.BulletMath;
	import zest3d.ext.bullet.math.BulletMatrix3x3;
	import zest3d.ext.bullet.math.BulletVector3;
	import zest3d.scenegraph.Spatial;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletRigidBody extends BulletCollisionObject 
	{
		
		private var m_invInertiaTensorWorld : BulletMatrix3x3;
		private var m_linearVelocity : BulletVector3;
		private var m_angularVelocity : BulletVector3;
		private var m_linearFactor : BulletVector3;
		private var m_angularFactor : BulletVector3;
		private var m_gravity : BulletVector3;
		private var m_gravity_acceleration : BulletVector3;
		private var m_invInertiaLocal : BulletVector3;
		private var m_totalForce : BulletVector3;
		private var m_totalTorque : BulletVector3;
		private var m_invMass : BulletVector3;
		
		public function BulletRigidBody(shape : BulletCollisionShape, skin : Spatial = null, mass : Number = 0) 
		{
			pointer = createBodyInC(shape.pointer, mass);
			super(shape, skin, pointer);
			
			m_invInertiaTensorWorld = new BulletMatrix3x3(pointer + 260);
			m_linearVelocity = new BulletVector3(pointer + 308);
			m_angularVelocity = new BulletVector3(pointer + 324);
			m_linearFactor = new BulletVector3(pointer + 344);
			m_angularFactor = new BulletVector3(pointer + 508);
			m_gravity = new BulletVector3(pointer + 360);
			m_gravity_acceleration = new BulletVector3(pointer + 376);
			m_invInertiaLocal = new BulletVector3(pointer + 392);
			m_totalForce = new BulletVector3(pointer + 408);
			m_totalTorque = new BulletVector3(pointer + 424);
			m_invMass = new BulletVector3(pointer + 524);
		}
		
		/**
		 * add force to the rigidbody's mass center
		 */
		public function applyCentralForce(force : AVector) : void {
			var vec : AVector = BulletMath.vectorMultiply(force, m_linearFactor.v3d);
			m_totalForce.v3d = vec.add(m_totalForce.v3d);
			activate();
		}
		
		/**
		 * add torque to the rigidbody
		 */
		public function applyTorque(torque : AVector) : void {
			var vec : AVector = BulletMath.vectorMultiply(torque, m_angularFactor.v3d);
			m_totalTorque.v3d = vec.add(m_totalTorque.v3d);
			activate();
		}
		
		/**
		 * add force to the rigidbody, rel_pos is the position in body's local coordinates
		 */
		public function applyForce(force : AVector, rel_pos : AVector) : void {
			applyCentralForce(force);
			rel_pos.scale(1 / _scaling);
			var vec : AVector = BulletMath.vectorMultiply(force, m_linearFactor.v3d);
			applyTorque(rel_pos.crossProduct(vec));
		}
		
		/**
		 * add impulse to the rigidbody's mass center
		 */
		public function applyCentralImpulse(impulse : AVector) : void {
			var vec : AVector = BulletMath.vectorMultiply(impulse, m_linearFactor.v3d);
			vec.scale(inverseMass);
			m_linearVelocity.v3d = vec.add(m_linearVelocity.v3d);
			activate();
		}
		
		/**
		 * add a torque impulse to the rigidbody
		 */
		public function applyTorqueImpulse(torque : AVector) : void {
			var tor : AVector = torque.clone();
			var vec : AVector = BulletMath.vectorMultiply(new AVector(m_invInertiaTensorWorld.row1.dotProduct(tor), m_invInertiaTensorWorld.row2.dotProduct(tor), m_invInertiaTensorWorld.row3.dotProduct(tor)), m_angularFactor.v3d);
			m_angularVelocity.v3d = vec.add(m_angularVelocity.v3d);
			activate();
		}
		
		/**
		 * add a impulse to the rigidbody, rel_pos is the position in body's local coordinates
		 */
		public function applyImpulse(impulse : AVector, rel_pos : AVector) : void {
			if (inverseMass != 0) {
				applyCentralImpulse(impulse);
				rel_pos.scale(1 / _scaling);
				var vec : AVector = BulletMath.vectorMultiply(impulse, m_linearFactor.v3d);
				applyTorqueImpulse(rel_pos.crossProduct(vec));
			}
		}
		
		/**
		 * clear all force and torque to zero
		 */
		public function clearForces() : void {
			m_totalForce.v3d = new AVector();
			m_totalTorque.v3d = new AVector();
		}
		
		/**
		 * set the gravity of this rigidbody
		 */
		public function set gravity(acceleration : AVector) : void {
			if (inverseMass != 0) {
				var vec : AVector = acceleration.clone();
				vec.scale(1 / inverseMass);
				m_gravity.v3d = vec;
				activate();
			}
			m_gravity_acceleration.v3d = acceleration;
		}
		
		override public function set scale(sc:AVector):void {
			super.scale = sc;
			setBodyMassInC(pointer, mass);
		}
		
		override public function set transform(tr:HMatrix) : void {
			super.transform = tr;
			setBodyMassInC(pointer, mass);
		}
		
		public function get invInertiaTensorWorld() : HMatrix {
			return m_invInertiaTensorWorld.m3d;
		}
		
		public function get linearVelocity() : AVector {
			return m_linearVelocity.v3d;
		}
		
		public function set linearVelocity(v : AVector) : void {
			m_linearVelocity.v3d = v;
		}
		
		public function get angularVelocity() : AVector {
			return m_angularVelocity.v3d;
		}
		
		public function set angularVelocity(v : AVector) : void {
			m_angularVelocity.v3d = v;
		}
		
		public function get linearFactor() : AVector {
			return m_linearFactor.v3d;
		}
		
		public function set linearFactor(v : AVector) : void {
			m_linearFactor.v3d = v;
			
			var vec : AVector = v.clone();
			vec.scale(inverseMass);
			m_invMass.v3d = vec;
		}
		
		public function get angularFactor() : AVector {
			return m_angularFactor.v3d;
		}
		
		public function set angularFactor(v : AVector) : void {
			m_angularFactor.v3d = v;
		}
		
		public function get gravity() : AVector {
			return m_gravity.v3d;
		}
		
		public function get gravityAcceleration() : AVector {
			return m_gravity_acceleration.v3d;
		}
		
		public function get invInertiaLocal() : AVector {
			return m_invInertiaLocal.v3d;
		}
		
		public function set invInertiaLocal(v : AVector) : void {
			m_invInertiaLocal.v3d = v;
		}
		
		public function get totalForce() : AVector {
			return m_totalForce.v3d;
		}
		
		public function get totalTorque() : AVector {
			return m_totalTorque.v3d;
		}
		
		public function get mass() : Number {
			return (inverseMass == 0)?0:1 / inverseMass;
		}
		
		public function set mass(v : Number) : void {
			setBodyMassInC(pointer, v);
			var physicsWorld:BulletDynamicsWorld = BulletDynamicsWorld.getInstance();
			if (v == 0) {
				if (physicsWorld.nonStaticRigidBodies.indexOf(this) >= 0) {
					physicsWorld.nonStaticRigidBodies.splice(physicsWorld.nonStaticRigidBodies.indexOf(this), 1);
				}
			} else {
				if (physicsWorld.nonStaticRigidBodies.indexOf(this) < 0) {
					physicsWorld.nonStaticRigidBodies.push(this);
				}
			}
			activate();
		}
		
		public function get inverseMass() : Number {
			return CModule.readFloat(pointer + 340);
		}
		
		public function set inverseMass(v : Number) : void {
			CModule.writeFloat(pointer + 340, v);
		}
		
		public function get linearDamping() : Number {
			return CModule.readFloat(pointer + 440);
		}
		
		public function set linearDamping(v : Number) : void {
			CModule.writeFloat(pointer + 440, v);
		}
		
		public function get angularDamping() : Number {
			return CModule.readFloat(pointer + 444);
		}
		
		public function set angularDamping(v : Number) : void {
			CModule.writeFloat(pointer + 444, v);
		}
		
		public function get linearSleepingThreshold() : Number {
			return CModule.readFloat(pointer + 468);
		}
		
		public function set linearSleepingThreshold(v : Number) : void {
			CModule.writeFloat(pointer + 468, v);
		}
		
		public function get angularSleepingThreshold() : Number {
			return CModule.readFloat(pointer + 472);
		}
		
		public function set angularSleepingThreshold(v : Number) : void {
			CModule.writeFloat(pointer + 472, v);
		}
		
		public function get rigidbodyFlags() : int {
			return CModule.read32(pointer + 500);
		}
		
		public function set rigidbodyFlags(v : int) : void {
			CModule.write32(pointer + 500, v);
		}
		
	}

}