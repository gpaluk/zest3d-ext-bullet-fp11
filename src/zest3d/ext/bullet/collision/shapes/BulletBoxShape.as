package zest3d.ext.bullet.collision.shapes 
{
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletBoxShape extends BulletCollisionShape 
	{
		import AWPC_Run.createBoxShapeInC;
		import AWPC_Run.CModule;
		import io.plugin.math.algebra.AVector;
		import zest3d.ext.bullet.math.BulletVector3;
		
		private var _dimensions:AVector;
		
		public function BulletBoxShape(width : Number = 100, height : Number = 100, depth : Number = 100) 
		{
			_dimensions = new AVector(width, height, depth);
			var vec:BulletVector3 = new BulletVector3();
			vec.sv3d = new AVector(width, height, depth);
			pointer = createBoxShapeInC(vec.pointer);
			CModule.free(vec.pointer);
			super(pointer, 0);
		}
		
		public function get dimensions():AVector {
			return new AVector(_dimensions.x * m_localScaling.x, _dimensions.y * m_localScaling.y, _dimensions.z * m_localScaling.z);
		}
		
	}

}