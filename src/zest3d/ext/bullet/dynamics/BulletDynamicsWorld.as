package zest3d.ext.bullet.dynamics 
{
	import AWPC_Run.addBodyInC;
	import AWPC_Run.addBodyWithGroupInC;
	import AWPC_Run.addCharacterInC;
	import AWPC_Run.addConstraintInC;
	import AWPC_Run.addVehicleInC;
	import AWPC_Run.CModule;
	import AWPC_Run.createDiscreteDynamicsWorldWithAxisSweep3InC;
	import AWPC_Run.createDiscreteDynamicsWorldWithDbvtInC;
	import AWPC_Run.disposeDynamicsWorldInC;
	import AWPC_Run.physicsStepInC;
	import AWPC_Run.removeBodyInC;
	import AWPC_Run.removeCharacterInC;
	import AWPC_Run.removeCollisionObjectInC;
	import AWPC_Run.removeConstraintInC;
	import AWPC_Run.removeVehicleInC;
	import com.adobe.flascc.Console;
	import flash.utils.Dictionary;
	import io.plugin.math.algebra.AVector;
	import zest3d.ext.bullet.collision.dispatch.BulletCollisionObject;
	import zest3d.ext.bullet.collision.dispatch.BulletCollisionWorld;
	import zest3d.ext.bullet.dynamics.character.BulletKinematicCharacterController;
	import zest3d.ext.bullet.dynamics.constraintsolver.BulletTypedConstraint;
	import zest3d.ext.bullet.dynamics.vehicle.BulletRaycastVehicle;
	import zest3d.ext.bullet.flags.BulletCollisionFlag;
	import zest3d.ext.bullet.math.BulletVector3;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletDynamicsWorld extends BulletCollisionWorld 
	{
		
		private static var currentDynamicsWorld : BulletDynamicsWorld;
		private var m_gravity : BulletVector3;
		private var m_rigidBodies : Vector.<BulletRigidBody>;
		private var m_nonStaticRigidBodies : Vector.<BulletRigidBody>;
		private var m_vehicles : Vector.<BulletRaycastVehicle>;
		private var m_characters : Vector.<BulletKinematicCharacterController>;
		private var m_constraints:Vector.<BulletTypedConstraint>;
		
		public static function getInstance() : BulletDynamicsWorld {
			if (!currentDynamicsWorld) {
				/*
				if (Away3D.MAJOR_VERSION ==4 && Away3D.MINOR_VERSION < 1)
					throw new Error("Incorrect AWAY3D version "+Away3D.MAJOR_VERSION+"."+Away3D.MINOR_VERSION+ ". Use Away3D 4.1 or higher");
				trace("version: AwayPhysics v1.0 alpha (4-9-2013)");
				*/
				currentDynamicsWorld = new BulletDynamicsWorld();
			}
			return currentDynamicsWorld;
		}
		
		public function BulletDynamicsWorld() 
		{
			CModule.startAsync(this);
			new Console(this);
			m_rigidBodies = new Vector.<BulletRigidBody>();
			m_nonStaticRigidBodies = new Vector.<BulletRigidBody>();
			m_vehicles = new Vector.<BulletRaycastVehicle>();
			m_characters = new Vector.<BulletKinematicCharacterController>();
			m_constraints = new Vector.<BulletTypedConstraint>();
		}
		
		/**
		 * init the physics world with btDbvtBroadphase
		 * refer to http://bulletphysics.org/mediawiki-1.5.8/index.php/Broadphase
		 */
		public function initWithDbvtBroadphase() : void {
			pointer = createDiscreteDynamicsWorldWithDbvtInC();
			m_gravity = new BulletVector3(pointer + 256);
			this.gravity = new AVector(0, 10, 0);
		}
		
		/**
		 * init the physics world with btAxisSweep3
		 * refer to http://bulletphysics.org/mediawiki-1.5.8/index.php/Broadphase
		 */
		public function initWithAxisSweep3(worldAabbMin : AVector, worldAabbMax : AVector) : void {
			var vec1:BulletVector3 = new BulletVector3();
			vec1.sv3d = worldAabbMin;
			var vec2:BulletVector3 = new BulletVector3();
			vec2.sv3d = worldAabbMax;
			pointer = createDiscreteDynamicsWorldWithAxisSweep3InC(vec1.pointer, vec2.pointer);
			CModule.free(vec1.pointer);
			CModule.free(vec2.pointer);
			m_gravity = new BulletVector3(pointer + 256);
			this.gravity = new AVector(0, 10, 0);
		}
		
		/**
		 * dispose the physics world
		 */
		public function dispose():void {
			disposeDynamicsWorldInC();
		}
		
		/**
		 * add a rigidbody to physics world
		 */
		public function addRigidBody(body : BulletRigidBody) : void {
			if (body.collisionFlags != BulletCollisionFlag.STATIC_OBJECT) {
				if (m_nonStaticRigidBodies.indexOf(body) < 0) {
					m_nonStaticRigidBodies.push(body);
				}
			}
			if (m_rigidBodies.indexOf(body) < 0) {
				m_rigidBodies.push(body);
				addBodyInC(body.pointer);
			}
			if(!m_collisionObjects.hasOwnProperty(body.pointer.toString())){
				m_collisionObjects[body.pointer.toString()] = body;
			}
		}
		
		/**
		 * add a rigidbody to physics world with group and mask
		 * refer to: http://bulletphysics.org/mediawiki-1.5.8/index.php/Collision_Filtering
		 */
		public function addRigidBodyWithGroup(body : BulletRigidBody, group : int, mask : int) : void {
			if (body.collisionFlags != BulletCollisionFlag.STATIC_OBJECT) {
				if (m_nonStaticRigidBodies.indexOf(body) < 0) {
					m_nonStaticRigidBodies.push(body);
				}
			}
			if (m_rigidBodies.indexOf(body) < 0) {
				m_rigidBodies.push(body);
				addBodyWithGroupInC(body.pointer, group, mask);
			}
			if(!m_collisionObjects.hasOwnProperty(body.pointer.toString())){
				m_collisionObjects[body.pointer.toString()] = body;
			}
		}
		
		/**
		 * remove a rigidbody from physics world, if cleanup is true, release pointer in memory.
		 */
		public function removeRigidBody(body : BulletRigidBody, cleanup:Boolean = false) : void {
			if (m_nonStaticRigidBodies.indexOf(body) >= 0) {
				m_nonStaticRigidBodies.splice(m_nonStaticRigidBodies.indexOf(body), 1);
			}
			if (m_rigidBodies.indexOf(body) >= 0) {
				m_rigidBodies.splice(m_rigidBodies.indexOf(body), 1);
				removeBodyInC(body.pointer);
				
				if (cleanup) {
					body.dispose();
				}
			}
			if(m_collisionObjects.hasOwnProperty(body.pointer.toString())){
				delete m_collisionObjects[body.pointer.toString()];
			}
		}
		
		/**
		 * add a constraint to physics world
		 */
		public function addConstraint(constraint : BulletTypedConstraint, disableCollisionsBetweenLinkedBodies : Boolean = false) : void {
			if (m_constraints.indexOf(constraint) < 0) {
				m_constraints.push(constraint);
				addConstraintInC(constraint.pointer, disableCollisionsBetweenLinkedBodies ? 1 : 0);
			}
		}
		
		/**
		 * remove a constraint from physics world, if cleanup is true, release pointer in memory.
		 */
		public function removeConstraint(constraint : BulletTypedConstraint, cleanup:Boolean = false) : void {
			if (m_constraints.indexOf(constraint) >= 0) {
				m_constraints.splice(m_constraints.indexOf(constraint), 1);
				removeConstraintInC(constraint.pointer);
				
				if (cleanup) {
					constraint.dispose();
				}
			}
		}
		
		/**
		 * add a vehicle to physics world
		 */
		public function addVehicle(vehicle : BulletRaycastVehicle) : void {
			if (m_vehicles.indexOf(vehicle) < 0) {
				m_vehicles.push(vehicle);
				addVehicleInC(vehicle.pointer);
			}
		}
		
		/**
		 * remove a vehicle from physics world, if cleanup is true, release pointer in memory.
		 */
		public function removeVehicle(vehicle : BulletRaycastVehicle, cleanup:Boolean = false) : void {
			if (m_vehicles.indexOf(vehicle) >= 0) {
				m_vehicles.splice(m_vehicles.indexOf(vehicle), 1);
				removeVehicleInC(vehicle.pointer);
				
				if (cleanup) {
					removeRigidBody(vehicle.getRigidBody(),cleanup);
					vehicle.dispose();
				}
			}
		}
		
		/**
		 * add a character to physics world
		 */
		public function addCharacter(character : BulletKinematicCharacterController, group : int = 32, mask : int = -1) : void {
			if (m_characters.indexOf(character) < 0) {
				m_characters.push(character);
				addCharacterInC(character.pointer, group, mask);
			}
			
			if(!m_collisionObjects.hasOwnProperty(character.ghostObject.pointer.toString())){
				m_collisionObjects[character.ghostObject.pointer.toString()] = character.ghostObject;
			}
		}
		
		/**
		 * remove a character from physics world, if cleanup is true, release pointer in memory.
		 */
		public function removeCharacter(character : BulletKinematicCharacterController, cleanup:Boolean = false) : void {
			if (m_characters.indexOf(character) >= 0) {
				m_characters.splice(m_characters.indexOf(character), 1);
				removeCharacterInC(character.pointer);
				
				if (cleanup) {
					character.dispose();
				}
			}
			if(m_collisionObjects.hasOwnProperty(character.ghostObject.pointer.toString())){
				delete m_collisionObjects[character.ghostObject.pointer.toString()];
			}
		}
		
		/**
		 * clear all objects from physics world, if cleanup is true, release pointer in memory.
		 */
		public function cleanWorld(cleanup:Boolean = false):void{
			while (m_constraints.length > 0){
				removeConstraint(m_constraints[0],cleanup);
			}
			m_constraints.length = 0;
			
			while (m_vehicles.length > 0){
				removeVehicle(m_vehicles[0],cleanup);
			}
			m_vehicles.length = 0;
			
			while (m_characters.length > 0){
				removeCharacter(m_characters[0],cleanup);
			}
			m_characters.length = 0;
			
			while (m_rigidBodies.length > 0){
				removeRigidBody(m_rigidBodies[0],cleanup);
			}
			m_nonStaticRigidBodies.length = 0;
			m_rigidBodies.length = 0;
			
			for each (var obj:BulletCollisionObject in m_collisionObjects) {
				removeCollisionObjectInC(obj.pointer);
			}
			m_collisionObjects =  new Dictionary(true);
		}
		
		/**
		 * get the gravity of physics world
		 */
		public function get gravity() : AVector {
			return m_gravity.v3d;
		}
		
		/**
		 * set the gravity of physics world
		 */
		public function set gravity(g : AVector) : void {
			m_gravity.v3d = g;
			for each (var body:BulletRigidBody in m_nonStaticRigidBodies) {
				body.gravity = g;
			}
		}
		
		/**
		 * get all rigidbodies
		 */
		public function get rigidBodies() : Vector.<BulletRigidBody> {
			return m_rigidBodies;
		}
		
		/**
		 * get all non static rigidbodies
		 */
		public function get nonStaticRigidBodies() : Vector.<BulletRigidBody> {
			return m_nonStaticRigidBodies;
		}
		
		public function get constraints() : Vector.<BulletTypedConstraint> {
			return m_constraints;
		}
		
		public function get vehicles() : Vector.<BulletRaycastVehicle> {
			return m_vehicles;
		}
		
		public function get characters() : Vector.<BulletKinematicCharacterController> {
			return m_characters;
		}
		
		/**
		 * set physics world scaling
		 * refer to http://www.bulletphysics.org/mediawiki-1.5.8/index.php?title=Scaling_The_World
		 */
		public function set scaling(v : Number) : void {
			_scaling = v;
		}
		
		/**
		 * get physics world scaling
		 */
		public function get scaling() : Number {
			return _scaling;
		}
		
		/**
		 * get if implement object collision callback
		 */
		public function get collisionCallbackOn() : Boolean {
			return CModule.read8(pointer + 280) == 1;
		}
		
		/**
		 * set this to true if need add a collision event to object, default is false
		 */
		public function set collisionCallbackOn(v : Boolean) : void {
			CModule.write8(pointer + 280, v ? 1 : 0);
		}
		
		/**
		 * set time step and simulate the physics world
		 * refer to: http://bulletphysics.org/mediawiki-1.5.8/index.php/Stepping_the_World
		 */
		public function step(timeStep : Number, maxSubSteps : int = 1, fixedTimeStep : Number = 1.0 / 60) : void {
			physicsStepInC(timeStep, maxSubSteps, fixedTimeStep);
			
			for each (var body:BulletRigidBody in m_nonStaticRigidBodies) {
				body.updateTransform();
			}
			
			for each (var vehicle:BulletRaycastVehicle in m_vehicles) {
				vehicle.updateWheelsTransform();
			}
			
			for each (var character:BulletKinematicCharacterController in m_characters) {
				character.updateTransform();
			}
		}
		
	}

}