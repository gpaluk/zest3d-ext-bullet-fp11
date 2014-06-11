package zest3d.ext.bullet.math 
{
	import AWPC_Run.matrix3x3;
	import io.plugin.math.algebra.AVector;
	import io.plugin.math.algebra.HMatrix;
	import zest3d.ext.bullet.BulletBase;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletMatrix3x3 extends BulletBase 
	{
		
		private var _row1 : BulletVector3;
		private var _row2 : BulletVector3;
		private var _row3 : BulletVector3;
		
		private var _m3d : HMatrix = new HMatrix();
		private var _v3d : AVector = new AVector();
		
		public function BulletMatrix3x3(ptr : uint = 0) 
		{
			if(ptr>0){
				pointer = ptr;
			}else{
				pointer = matrix3x3();
			}
			_row1 = new BulletVector3(pointer + 0);
			_row2 = new BulletVector3(pointer + 16);
			_row3 = new BulletVector3(pointer + 32);
		}
		
		public function get row1():AVector {
			return _row1.v3d;
		}
		
		public function get row2():AVector {
			return _row2.v3d;
		}
		
		public function get row3():AVector {
			return _row3.v3d;
		}
		
		public function get column1():AVector {
			return new AVector(_row1.x, _row2.x, _row3.x);
		}
		
		public function get column2():AVector {
			return new AVector(_row1.y, _row2.y, _row3.y);
		}
		
		public function get column3():AVector {
			return new AVector(_row1.z, _row2.z, _row3.z);
		}
		
		public function get m3d(): HMatrix {
			
			var r0:Array = _m3d.getRow(0);
			_v3d.set( r0[0], r0[1], r0[2] );
			_row1.v3d = _v3d;
			
			var r1:Array = _m3d.getRow(1);
			_v3d.set( r1[0], r1[1], r1[2] );
			_row2.v3d = _v3d;
			
			var r2:Array = _m3d.getRow(2);
			_v3d.set( r2[0], r2[1], r2[2] );
			_row3.v3d = _v3d;
			
			return _m3d;
		}
		
		public function set m3d(m : HMatrix) : void {
			_v3d.set(m.m00, m.m10, m.m20);
			_row1.v3d = _v3d;
			_v3d.set(m.m01, m.m11, m.m21);
			_row2.v3d = _v3d;
			_v3d.set(m.m02, m.m12, m.m22);
			_row3.v3d = _v3d;
		}
		
	}

}