package zest3d.ext.bullet.math 
{
	import io.plugin.math.algebra.AVector;
	import io.plugin.math.algebra.HMatrix;
	import zest3d.ext.bullet.BulletBase;
	
	/**
	 * ...
	 * 
	 * TODO optimize with the Zest3D Transform which already stores transforms as discreetly
	 * seperated translations, rotations and scales.
	 * 
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletTransform extends BulletBase 
	{
		
		private var m_basis : BulletMatrix3x3;
		private var m_origin : BulletVector3;
		
		private var _transData:Vector.<AVector>;
		private var _transform:HMatrix = new HMatrix();
		
		public function BulletTransform(ptr : uint = 0) 
		{
			pointer = ptr;
			
			_transData = new Vector.<AVector>(3, true);
			
			if (ptr > 0) {	
				m_basis = new BulletMatrix3x3(ptr + 0);
				m_origin = new BulletVector3(ptr + 48);
				
				_transData[0] = m_origin.sv3d;
				_transData[1] = BulletMath.matrix2euler(m_basis.m3d);
				
				_transData[2] = new AVector(1, 1, 1);
			}else {
				m_basis = null;
				m_origin = null;
				
				_transData[0] = new AVector();
				_transData[1] = new AVector();
				_transData[2] = new AVector(1, 1, 1);
			}
		}
		
		public function get origin():BulletVector3 {
			return m_origin;
		}
		
		public function get basis():BulletMatrix3x3 {
			return m_basis;
		}
		
		public function get position():AVector {
			if (m_origin) {
				return m_origin.sv3d;
			}else {
				return _transData[0];
			}
		}
		
		public function set position(v:AVector):void {
			_transData[0] = v;
			if (m_origin) {
				m_origin.sv3d = v;
			}
		}
		
		/**
		 * get the euler angle in radians
		 */
		public function get rotation():AVector {
			if (m_basis) {
				return BulletMath.matrix2euler(m_basis.m3d);
			}else {
				return _transData[1];
			}
		}
		
		/**
		 * set the euler angle in radians
		 */
		public function set rotation(v:AVector):void {
			_transData[1] = v;
			if (m_basis) {
				m_basis.m3d = BulletMath.euler2matrix(v);
			}
		}
		
		public function get rotationWithMatrix():HMatrix {
			if (m_basis) {
				return m_basis.m3d;
			}else {
				return BulletMath.euler2matrix(_transData[1]);
			}
		}
		
		public function set rotationWithMatrix(m:HMatrix):void {
			_transData[1] = BulletMath.matrix2euler(m);
			if (m_basis) {
				m_basis.m3d = m;
			}
		}
		
		public function get axisX():AVector {
			var m:HMatrix = this.rotationWithMatrix;
			return new AVector(m.m00, m.m10, m.m20);
		}
		
		public function get axisY():AVector {
			var m:HMatrix = this.rotationWithMatrix;
			return new AVector(m.m01, m.m11, m.m21);
		}
		
		public function get axisZ():AVector {
			var m:HMatrix = this.rotationWithMatrix;
			return new AVector(m.m02, m.m12, m.m22);
		}
		
		public function get transform():HMatrix {
			if (m_origin && m_basis) {
				_transData[0] = m_origin.sv3d;
				_transData[1] = BulletMath.matrix2euler(m_basis.m3d);
			}
			_transform.identity();
			_transform.recompose(_transData);
			
			return _transform;
		}
		
		public function set transform(m:HMatrix):void {
			_transData = m.decompose();
			_transData[2].set(1, 1, 1);
			if (m_origin && m_basis) {
				m_origin.sv3d = _transData[0];
				m_basis.m3d = BulletMath.euler2matrix(_transData[1]);
			}
		}
		
		public function appendTransform(tr:BulletTransform):void {
			var m:HMatrix = this.transform;
			m.multiplyEq(tr.transform);
			this.transform = m;
		}
		
		public function clone():BulletTransform {
			var tr:BulletTransform = new BulletTransform();
			tr.transform = this.transform;
			return tr;
		}
	}
}