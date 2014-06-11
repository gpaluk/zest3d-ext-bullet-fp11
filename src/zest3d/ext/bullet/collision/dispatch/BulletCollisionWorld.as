package zest3d.ext.bullet.collision.dispatch 
{
	import AWPC_Run.addCollisionObjectInC;
	import AWPC_Run.removeCollisionObjectInC;
	import flash.utils.Dictionary;
	import zest3d.ext.bullet.BulletBase;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletCollisionWorld extends BulletBase 
	{
		protected var m_collisionObjects:Dictionary;
		
		public function BulletCollisionWorld() 
		{
			m_collisionObjects =  new Dictionary(true);
		}
		
		public function get collisionObjects() : Dictionary {
			return m_collisionObjects;
		}
		
		/**
		 * add a collisionObject to collision world
		 */
		public function addCollisionObject(obj:BulletCollisionObject, group:int = 1, mask:int = -1):void{
			if(!m_collisionObjects.hasOwnProperty(obj.pointer.toString())){
				m_collisionObjects[obj.pointer.toString()] = obj;
				addCollisionObjectInC(obj.pointer, group, mask);
			}
		}
		
		/**
		 * remove a collisionObject from collision world, if cleanup is true, release pointer in memory.
		 */
		public function removeCollisionObject(obj:BulletCollisionObject, cleanup:Boolean = false) : void {			
			if(m_collisionObjects.hasOwnProperty(obj.pointer.toString())){
				delete m_collisionObjects[obj.pointer.toString()];
				removeCollisionObjectInC(obj.pointer);
				
				if (cleanup) {
					obj.dispose();
				}
			}
		}
	}

}