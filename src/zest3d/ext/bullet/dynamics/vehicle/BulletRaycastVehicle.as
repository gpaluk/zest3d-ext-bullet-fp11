package zest3d.ext.bullet.dynamics.vehicle 
{
	import AWPC_Run.addVehicleWheelInC;
	import AWPC_Run.CModule;
	import AWPC_Run.createVehicleInC;
	import AWPC_Run.disposeVehicleInC;
	import io.plugin.math.algebra.AVector;
	import zest3d.ext.bullet.BulletBase;
	import zest3d.ext.bullet.dynamics.BulletRigidBody;
	import zest3d.ext.bullet.math.BulletVector3;
	import zest3d.scenegraph.Spatial;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletRaycastVehicle extends BulletBase 
	{
		
		private var m_chassisBody : BulletRigidBody;
		private var m_wheelInfo : Vector.<BulletWheelInfo>;
		
		public function BulletRaycastVehicle(tuning : BulletVehicleTuning, chassis : BulletRigidBody) 
		{
			pointer = createVehicleInC(chassis.pointer,tuning.suspensionStiffness,tuning.suspensionCompression,tuning.suspensionDamping,tuning.maxSuspensionTravelCm,tuning.frictionSlip,tuning.maxSuspensionForce);
			
			m_chassisBody = chassis;
			m_wheelInfo = new Vector.<BulletWheelInfo>();
		}
		
		public function getRigidBody() : BulletRigidBody {
			return m_chassisBody;
		}
		
		public function getNumWheels() : int {
			return m_wheelInfo.length;
		}
		
		public function getWheelInfo(index : int) : BulletWheelInfo {
			if (index < m_wheelInfo.length) {
				return m_wheelInfo[index];
			}
			return null;
		}
		
		public function addWheel(_skin : Spatial, connectionPointCS0 : AVector, wheelDirectionCS0 : AVector, wheelAxleCS : AVector, suspensionRestLength : Number, wheelRadius : Number, tuning : BulletVehicleTuning, isFrontWheel : Boolean) : void {
			var vec1:BulletVector3 = new BulletVector3();
			vec1.sv3d = connectionPointCS0;
			var vec2:BulletVector3 = new BulletVector3();
			vec2.v3d = wheelDirectionCS0;
			var vec3:BulletVector3 = new BulletVector3();
			vec3.v3d = wheelAxleCS;
			var wp : uint = addVehicleWheelInC(pointer, vec1.pointer, vec2.pointer, vec3.pointer, tuning.suspensionStiffness,tuning.suspensionCompression,tuning.suspensionDamping,tuning.maxSuspensionTravelCm,tuning.frictionSlip,tuning.maxSuspensionForce,suspensionRestLength / _scaling, wheelRadius / _scaling, (isFrontWheel) ? 1 : 0);
			CModule.free(vec1.pointer);
			CModule.free(vec2.pointer);
			CModule.free(vec3.pointer);
			if (m_wheelInfo.length > 0) {
				var num : int = 0;
				for (var i : int = m_wheelInfo.length - 1; i >= 0; i-- ) {
					num += 1;
					m_wheelInfo[i] = new BulletWheelInfo(wp - 284 * num, m_wheelInfo[i].skin);
				}
			}
			
			m_wheelInfo.push(new BulletWheelInfo(wp, _skin));
		}
		
		public function applyEngineForce(force : Number, wheelIndex : int) : void {
			m_wheelInfo[wheelIndex].engineForce = force;
		}
		
		public function setBrake(brake : Number, wheelIndex : int) : void {
			m_wheelInfo[wheelIndex].brake = brake;
		}
		
		public function setSteeringValue(steering : Number, wheelIndex : int) : void {
			m_wheelInfo[wheelIndex].steering = steering;
		}
		
		public function getSteeringValue(wheelIndex : int) : Number {
			return m_wheelInfo[wheelIndex].steering;
		}
		
		public function updateWheelsTransform() : void {
			for each (var wheel:BulletWheelInfo in m_wheelInfo) {
				wheel.updateTransform();
			}
		}
		
		public function dispose():void {
			if (!_cleanup) {
				_cleanup = true;
				disposeVehicleInC(pointer);
			}
		}
	}

}