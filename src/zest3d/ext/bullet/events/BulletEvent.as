package zest3d.ext.bullet.events 
{
	import flash.events.Event;
	import zest3d.ext.bullet.collision.dispatch.BulletCollisionObject;
	import zest3d.ext.bullet.collision.dispatch.BulletManifoldPoint;
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletEvent extends Event {
	
		/**
		 * Dispatched when the body occur collision
		 */
		public static const COLLISION_ADDED : String = "collisionAdded";
		/**
		 * Dispatched when ray collide
		 */
		 public static const RAY_CAST : String = "rayCast";
		/**
		 * stored which object is collide with target object
		 */
		public var collisionObject : BulletCollisionObject;
		/**
		 * stored collision point, normal, impulse etc.
		 */
		public var manifoldPoint : BulletManifoldPoint;
		
		public function BulletEvent(type : String) {
			super(type);
		}
	}
}