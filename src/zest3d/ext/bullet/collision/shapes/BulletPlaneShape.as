package zest3d.ext.bullet.collision.shapes 
{
	import AWPC_Run.CModule;
	import AWPC_Run.createStaticPlaneShapeInC;
	import io.plugin.math.algebra.AVector;
	import zest3d.ext.bullet.math.BulletVector3;
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletPlaneShape extends BulletCollisionShape 
	{
		
		private var _normal:AVector;
		private var _constant:Number;
		
		public function BulletPlaneShape( normal : AVector = null, constant : Number = 0) 
		{
			if (!normal) {
				normal = new AVector(0, 1, 0);
			}
			_normal = normal;
			_constant = constant;
			
			var vec:BulletVector3 = new BulletVector3();
			vec.v3d = normal;
			pointer = createStaticPlaneShapeInC(vec.pointer, constant / _scaling);
			CModule.free(vec.pointer);
			super(pointer, 8);
		}
		
		public function get normal():AVector {
			return _normal;
		}
		
		public function get constant():Number {
			return _constant;
		}
	}

}