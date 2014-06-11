package zest3d.ext.bullet.collision.shapes 
{
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletCylinderShape extends BulletCollisionShape 
	{
		
		import AWPC_Run.CModule;
		import AWPC_Run.createCylinderShapeInC;
		import io.plugin.math.algebra.AVector;
		import zest3d.ext.bullet.math.BulletVector3;
		
		private var _radius:Number;
		private var _height:Number;
		
		public function BulletCylinderShape(radius : Number = 50, height : Number = 100) 
		{
			_radius = radius;
			_height = height;
			
			var vec:BulletVector3 = new BulletVector3();
			vec.v3d = new AVector(radius * 2 / _scaling, height / _scaling, radius * 2 / _scaling)
			pointer = createCylinderShapeInC(vec.pointer);
			CModule.free(vec.pointer);
			super(pointer, 2);
		}
		
		public function get radius():Number {
			return _radius * m_localScaling.x;
		}
		
		public function get height():Number {
			return _height * m_localScaling.y;
		}
		
	}

}