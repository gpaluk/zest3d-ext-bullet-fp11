package zest3d.ext.bullet.dynamics.character 
{
	import AWPC_Run.CModule;
	import AWPC_Run.createCharacterInC;
	import AWPC_Run.disposeCharacterInC;
	import io.plugin.math.algebra.AVector;
	import zest3d.ext.bullet.BulletBase;
	import zest3d.ext.bullet.collision.dispatch.BulletGhostObject;
	import zest3d.ext.bullet.math.BulletVector3;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletKinematicCharacterController extends BulletBase 
	{
		
		private var m_ghostObject : BulletGhostObject;
		private var m_walkDirection : BulletVector3;
		private var m_normalizedDirection : BulletVector3;
		
		public function BulletKinematicCharacterController(ghostObject : BulletGhostObject, stepHeight : Number) 
		{
			m_ghostObject = ghostObject;
			
			pointer = createCharacterInC(ghostObject.pointer, ghostObject.shape.pointer, stepHeight, 1);
			
			m_walkDirection = new BulletVector3(pointer + 60);
			m_normalizedDirection = new BulletVector3(pointer + 76);
		}
		
		public function get ghostObject() : BulletGhostObject {
			return m_ghostObject;
		}
		
		public function dispose():void {
			if (!_cleanup) {
				_cleanup	= true;
				m_ghostObject.dispose();
				disposeCharacterInC(pointer);
			}
		}
		
		/**
		 * called by dynamicsWorld
		 */
		public function updateTransform() : void {
			m_ghostObject.updateTransform();
		}
		
		public function get walkDirection() : AVector {
			return m_walkDirection.v3d;
		}
		
		/**
		 * set the walk direction and speed
		 */
		public function setWalkDirection(walkDirection : AVector) : void {
			useWalkDirection = true;
			m_walkDirection.v3d = walkDirection;
			var vec : AVector = walkDirection.clone();
			vec.normalize();
			m_normalizedDirection.v3d = vec;
		}
		
		/**
		 * set the walk direction and speed with time interval
		 */
		public function setVelocityForTimeInterval(velocity : AVector, timeInterval : Number) : void {
			useWalkDirection = false;
			m_walkDirection.v3d = velocity;
			var vec : AVector = velocity.clone();
			vec.normalize();
			m_normalizedDirection.v3d = vec;
			velocityTimeInterval = timeInterval;
		}
		
		/**
		 * set the character's position in world coordinates
		 */
		public function warp(origin : AVector) : void {
			m_ghostObject.position = origin;
		}
		
		/**
		 * whether character contact with ground
		 */
		public function onGround() : Boolean {
			return (verticalVelocity == 0 && verticalOffset == 0);
		}
		
		/**
		 * whether character can jump (on the ground)
		 */
		public function canJump() : Boolean {
			return onGround();
		}
		
		public function jump() : void {
			if (!canJump())
				return;
			
			verticalVelocity = jumpSpeed;
			wasJumping = true;
		}
		
		/**
		 * The max slope determines the maximum angle that the controller can walk up.
		 * The slope angle is measured in radians.
		 */
		public function setMaxSlope(slopeRadians : Number) : void {
			maxSlopeRadians = slopeRadians;
			maxSlopeCosine = Math.cos(slopeRadians);
		}
		
		public function getMaxSlope() : Number {
			return maxSlopeRadians;
		}
		
		public function get fallSpeed() : Number {
			return CModule.readFloat(pointer + 24);
		}
		
		public function set fallSpeed(v : Number) : void {
			CModule.writeFloat(pointer + 24, v);
		}
		
		public function get jumpSpeed() : Number {
			return CModule.readFloat(pointer + 28);
		}
		
		public function set jumpSpeed(v : Number) : void {
			CModule.writeFloat(pointer + 28, v);
		}
		
		public function get maxJumpHeight() : Number {
			return CModule.readFloat(pointer + 32) * _scaling;
		}
		
		public function set maxJumpHeight(v : Number) : void {
			CModule.writeFloat(pointer + 32, v / _scaling);
		}
		
		public function get gravity() : Number {
			return CModule.readFloat(pointer + 44);
		}
		
		public function set gravity(v : Number) : void {
			CModule.writeFloat(pointer + 44, v);
		}
		
		private function get wasJumping() : Boolean {
			return CModule.read8(pointer + 169) == 1;
		}
		
		private function set wasJumping(v : Boolean) : void {
			CModule.write8(pointer + 169, v ? 1 : 0);
		}
		
		private function get useWalkDirection() : Boolean {
			return CModule.read8(pointer + 171) == 1;
		}
		
		private function set useWalkDirection(v : Boolean) : void {
			CModule.write8(pointer + 171, v ? 1 : 0);
		}
		
		private function get velocityTimeInterval() : Number {
			return CModule.readFloat(pointer + 172);
		}
		
		private function set velocityTimeInterval(v : Number) : void {
			CModule.writeFloat(pointer + 172, v);
		}
		
		private function get verticalVelocity() : Number {
			return CModule.readFloat(pointer + 16);
		}
		
		private function set verticalVelocity(v : Number) : void {
			CModule.writeFloat(pointer + 16, v);
		}
		
		private function get verticalOffset() : Number {
			return CModule.readFloat(pointer + 20);
		}
		
		private function set verticalOffset(v : Number) : void {
			CModule.writeFloat(pointer + 20, v);
		}
		
		private function get maxSlopeRadians() : Number {
			return CModule.readFloat(pointer + 36);
		}
		
		private function set maxSlopeRadians(v : Number) : void {
			CModule.writeFloat(pointer + 36, v);
		}
		
		private function get maxSlopeCosine() : Number {
			return CModule.readFloat(pointer + 40);
		}
		
		private function set maxSlopeCosine(v : Number) : void {
			CModule.writeFloat(pointer + 40, v);
		}
	}
}