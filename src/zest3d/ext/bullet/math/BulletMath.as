package zest3d.ext.bullet.math 
{
	import io.plugin.math.algebra.AVector;
	import io.plugin.math.algebra.HMatrix;
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletMath 
	{
		
		public static const RADIANS_TO_DEGREES : Number = 180 / Math.PI;
		public static const DEGREES_TO_RADIANS : Number = Math.PI / 180;
		
		public static function matrix2euler( m:HMatrix ) : AVector
		{
			return m.decompose()[1];
		}
		
		public static function euler2matrix( ang:AVector ) : HMatrix
		{
			var m:HMatrix = new HMatrix();
			var data:Vector.<AVector> = Vector.<AVector>([new AVector(), ang, new AVector(1, 1, 1)]);
			m.recompose(data);
			return m;
		}
		
		public static function vectorMultiply(v1:AVector, v2:AVector):AVector {
			return new AVector(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z);
		}
		
		public static function degrees2radiansV3D(degrees:AVector):AVector {
			var deg:AVector = degrees.clone();
			deg.x *= BulletMath.DEGREES_TO_RADIANS;
			deg.y *= BulletMath.DEGREES_TO_RADIANS;
			deg.z *= BulletMath.DEGREES_TO_RADIANS;
			return deg;
		}
		
		public static function radians2degreesV3D(radians:AVector):AVector {
			var rad:AVector = radians.clone();
			rad.x *= BulletMath.RADIANS_TO_DEGREES;
			rad.y *= BulletMath.RADIANS_TO_DEGREES;
			rad.z *= BulletMath.RADIANS_TO_DEGREES;
			return rad;
		}
		
	}

}