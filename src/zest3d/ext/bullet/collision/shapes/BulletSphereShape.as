package zest3d.ext.bullet.collision.shapes 
{
	import AWPC_Run.createSphereShapeInC;
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletSphereShape extends BulletCollisionShape 
	{
		
		private var _radius:Number;
		
		public function BulletSphereShape(radius : Number = 50) 
		{
			_radius = radius;
			
			pointer = createSphereShapeInC(radius / _scaling);
			super(pointer, 1);
		}
		
		public function get radius():Number {
			return _radius * m_localScaling.x;
		}
	}

}