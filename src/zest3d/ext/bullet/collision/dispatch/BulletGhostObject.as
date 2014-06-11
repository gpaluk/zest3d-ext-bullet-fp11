package zest3d.ext.bullet.collision.dispatch 
{
	import AWPC_Run.createGhostObjectInC;
	import zest3d.ext.bullet.collision.shapes.BulletCollisionShape;
	import zest3d.scenegraph.Spatial;
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletGhostObject extends BulletCollisionObject 
	{
		
		public function BulletGhostObject(shape : BulletCollisionShape, skin : Spatial = null) 
		{
			pointer = createGhostObjectInC(shape.pointer);
			super(shape, skin, pointer);
		}
		
	}

}