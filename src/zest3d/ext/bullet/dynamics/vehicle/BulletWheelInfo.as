package zest3d.ext.bullet.dynamics.vehicle 
{
	import AWPC_Run.CModule;
	import io.plugin.math.algebra.APoint;
	import io.plugin.math.algebra.AVector;
	import zest3d.ext.bullet.BulletBase;
	import zest3d.ext.bullet.math.BulletMath;
	import zest3d.ext.bullet.math.BulletTransform;
	import zest3d.ext.bullet.math.BulletVector3;
	import zest3d.scenegraph.Spatial;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletWheelInfo extends BulletBase 
	{
		private var m_skin : Spatial;
		private var m_raycastInfo : BulletRaycastInfo;
		private var m_worldTransform : BulletTransform;
		private var m_chassisConnectionPointCS : BulletVector3;
		private var m_wheelDirectionCS : BulletVector3;
		private var m_wheelAxleCS : BulletVector3;
		
		public function BulletWheelInfo(ptr : uint, _skin : Spatial = null) 
		{
			pointer = ptr;
			m_skin = _skin;
			
			m_raycastInfo = new BulletRaycastInfo(ptr);
			m_worldTransform = new BulletTransform(ptr + 92);
			m_chassisConnectionPointCS = new BulletVector3(ptr + 156);
			m_wheelDirectionCS = new BulletVector3(ptr + 172);
			m_wheelAxleCS = new BulletVector3(ptr + 188);
		}
		
		public function get skin() : Spatial {
			return m_skin;
		}
		
		public function set skin(value:Spatial):void {
			m_skin = value;
		}
		
		public function get raycastInfo() : BulletRaycastInfo {
			return m_raycastInfo;
		}
		
		public function set worldPosition(pos : AVector) : void {
			m_worldTransform.position = pos;
			updateTransform();
		}
		
		public function get worldPosition() : AVector {
			return m_worldTransform.position;
		}
		
		public function set worldRotation(rot : AVector) : void {
			m_worldTransform.rotation = BulletMath.degrees2radiansV3D(rot);
			updateTransform();
		}
		
		public function get worldRotation() : AVector {
			return BulletMath.radians2degreesV3D(m_worldTransform.rotation);
		}
		
		public function updateTransform() : void {
			if (!m_skin) return;
			
			m_skin.scaleX = m_skin.scaleX;
			m_skin.scaleY = m_skin.scaleY;
			m_skin.scaleZ = m_skin.scaleZ;
			var rot:AVector = BulletMath.radians2degreesV3D(m_worldTransform.rotation);
			m_skin.rotate(rot.x,rot.y,rot.z);
			m_skin.position = APoint.fromTuple( m_worldTransform.position.toTuple() );
		}
		
		public function get chassisConnectionPointCS() : AVector {
			return m_chassisConnectionPointCS.sv3d;
		}
		
		public function set chassisConnectionPointCS(v : AVector) : void {
			m_chassisConnectionPointCS.sv3d = v;
		}
		
		public function get wheelDirectionCS() : AVector {
			return m_wheelDirectionCS.v3d;
		}
		
		public function set wheelDirectionCS(v : AVector) : void {
			m_wheelDirectionCS.v3d = v;
		}
		
		public function get wheelAxleCS() : AVector {
			return m_wheelAxleCS.v3d;
		}
		
		public function set wheelAxleCS(v : AVector) : void {
			m_wheelAxleCS.v3d = v;
		}
		
		public function get suspensionRestLength1() : Number {
			return CModule.readFloat(pointer + 204) * _scaling;
		}
		
		public function set suspensionRestLength1(v : Number) : void {
			CModule.writeFloat(pointer + 204, v / _scaling);
		}
		
		public function get maxSuspensionTravelCm() : Number {
			return CModule.readFloat(pointer + 208);
		}
		
		public function set maxSuspensionTravelCm(v : Number) : void {
			CModule.writeFloat(pointer + 208, v);
		}
		
		public function get wheelsRadius() : Number {
			return CModule.readFloat(pointer + 212) * _scaling;
		}
		
		public function set wheelsRadius(v : Number) : void {
			CModule.writeFloat(pointer + 212, v / _scaling);
		}
		
		public function get suspensionStiffness() : Number {
			return CModule.readFloat(pointer + 216);
		}
		
		public function set suspensionStiffness(v : Number) : void {
			CModule.writeFloat(pointer + 216, v);
		}
		
		public function get wheelsDampingCompression() : Number {
			return CModule.readFloat(pointer + 220);
		}
		
		public function set wheelsDampingCompression(v : Number) : void {
			CModule.writeFloat(pointer + 220, v);
		}
		
		public function get wheelsDampingRelaxation() : Number {
			return CModule.readFloat(pointer + 224);
		}
		
		public function set wheelsDampingRelaxation(v : Number) : void {
			CModule.writeFloat(pointer + 224, v);
		}
		
		public function get frictionSlip() : Number {
			return CModule.readFloat(pointer + 228);
		}
		
		public function set frictionSlip(v : Number) : void {
			CModule.writeFloat(pointer + 228, v);
		}
		
		public function get steering() : Number {
			return CModule.readFloat(pointer + 232);
		}
		
		public function set steering(v : Number) : void {
			CModule.writeFloat(pointer + 232, v);
		}
		
		public function get rotation() : Number {
			return CModule.readFloat(pointer + 236);
		}
		
		public function set rotation(v : Number) : void {
			CModule.writeFloat(pointer + 236, v);
		}
		
		public function get deltaRotation() : Number {
			return CModule.readFloat(pointer + 240);
		}
		
		public function set deltaRotation(v : Number) : void {
			CModule.writeFloat(pointer + 240, v);
		}
		
		public function get rollInfluence() : Number {
			return CModule.readFloat(pointer + 244);
		}
		
		public function set rollInfluence(v : Number) : void {
			CModule.writeFloat(pointer + 244, v);
		}
		
		public function get maxSuspensionForce() : Number {
			return CModule.readFloat(pointer + 248);
		}
		
		public function set maxSuspensionForce(v : Number) : void {
			CModule.writeFloat(pointer + 248, v);
		}
		
		public function get engineForce() : Number {
			return CModule.readFloat(pointer + 252);
		}
		
		public function set engineForce(v : Number) : void {
			CModule.writeFloat(pointer + 252, v);
		}
		
		public function get brake() : Number {
			return CModule.readFloat(pointer + 256);
		}
		
		public function set brake(v : Number) : void {
			CModule.writeFloat(pointer + 256, v);
		}
		
		public function get bIsFrontWheel() : Boolean {
			return CModule.read8(pointer + 260) == 1;
		}
		
		public function set bIsFrontWheel(v : Boolean) : void {
			CModule.write8(pointer + 260, v ? 1 : 0);
		}
		
		public function get suspensionRelativeVelocity() : Number {
			return CModule.readFloat(pointer + 272);
		}
		
		public function get wheelsSuspensionForce() : Number {
			return CModule.readFloat(pointer + 276);
		}
		
		public function get skidInfo() : Number {
			return CModule.readFloat(pointer + 280);
		}
	}

}