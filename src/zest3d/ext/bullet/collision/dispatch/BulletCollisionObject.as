package zest3d.ext.bullet.collision.dispatch 
{
	import AWPC_Run.addRayInC;
	import AWPC_Run.CModule;
	import AWPC_Run.createCollisionObjectInC;
	import AWPC_Run.disposeCollisionObjectInC;
	import AWPC_Run.removeRayInC;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import io.plugin.math.algebra.APoint;
	import io.plugin.math.algebra.AVector;
	import io.plugin.math.algebra.HMatrix;
	import zest3d.ext.bullet.BulletBase;
	import zest3d.ext.bullet.collision.shapes.BulletCollisionShape;
	import zest3d.ext.bullet.events.BulletEvent;
	import zest3d.ext.bullet.flags.BulletCollisionFlag;
	import zest3d.ext.bullet.math.BulletMath;
	import zest3d.ext.bullet.math.BulletTransform;
	import zest3d.ext.bullet.math.BulletVector3;
	import zest3d.scenegraph.Spatial;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletCollisionObject extends BulletBase implements IEventDispatcher
	{
		
		public static const ACTIVE_TAG : int = 1;
		public static const ISLAND_SLEEPING : int = 2;
		public static const WANTS_DEACTIVATION : int = 3;
		public static const DISABLE_DEACTIVATION : int = 4;
		public static const DISABLE_SIMULATION : int = 5;
		
		private var m_shape : BulletCollisionShape;
		private var m_skin : Spatial;
		private var m_worldTransform : BulletTransform;
		private var m_anisotropicFriction : BulletVector3;
		
		private var _rays:Vector.<BulletRay>;
		
		private var _originScale:AVector = new AVector(1, 1, 1);
		private var _dispatcher : EventDispatcher;
		
		public function BulletCollisionObject(shape : BulletCollisionShape, skin : Spatial, ptr : uint = 0) 
		{
			m_shape = shape;
			m_skin = skin;
			
			m_shape.retain();
			
			if(ptr>0){
				pointer = ptr;
				m_worldTransform = new BulletTransform(ptr + 4);
				m_anisotropicFriction = new BulletVector3(ptr + 164);
			}else{
				pointer = createCollisionObjectInC(shape.pointer);
				
				m_worldTransform = new BulletTransform(pointer + 4);
				m_anisotropicFriction = new BulletVector3(pointer + 164);
			}
			if (m_skin) {
				_originScale.set(m_skin.scaleX, m_skin.scaleY, m_skin.scaleZ);
			}
			
			_rays = new Vector.<BulletRay>();
			_dispatcher = new EventDispatcher(this);
		}
		
		
		
		
		
		
		public function get shape() : BulletCollisionShape {
			return m_shape;
		}
		
		public function get skin() : Spatial {
			return m_skin;
		}
		
		public function set skin(value:Spatial):void {
			m_skin = value;
			_originScale.set(m_skin.scaleX, m_skin.scaleY, m_skin.scaleZ);
		}
		
		public function dispose():void {
			if (!_cleanup) {
				_cleanup  = true;
				removeAllRays();
				m_shape.dispose();
				disposeCollisionObjectInC(pointer);
			}
		}
		
		/**
		 * update the transform of skin mesh
		 * called by dynamicsWorld
		 */
		public function updateTransform() : void {
			if (!m_skin) return;
			
			var vec:AVector = m_shape.localScaling;
			m_skin.scaleX = _originScale.x * vec.x;
			m_skin.scaleY = _originScale.y * vec.y;
			m_skin.scaleZ = _originScale.z * vec.z;
			vec = BulletMath.radians2degreesV3D(m_worldTransform.rotation);
			
			m_skin.rotate(vec.x,vec.y,vec.z);
			m_skin.position = APoint.fromTuple( m_worldTransform.position.toTuple() );
		}
		
		/**
		 * set the position in world coordinates
		 */
		public function set position(pos : AVector) : void {
			m_worldTransform.position = pos;
			updateTransform();
		}
		/**
		 * get the position in world coordinates
		 */
		public function get position() : AVector {
			return m_worldTransform.position;
		}
		
		/**
		 * set the position in x axis
		 */
		public function set x(v:Number):void {
			m_worldTransform.position = new AVector(v, m_worldTransform.position.y, m_worldTransform.position.z);
			updateTransform();
		}
		/**
		 * get the position in x axis
		 */
		public function get x():Number {
			return m_worldTransform.position.x;
		}
		
		/**
		 * set the position in y axis
		 */
		public function set y(v:Number):void {
			m_worldTransform.position = new AVector(m_worldTransform.position.x, v, m_worldTransform.position.z);
			updateTransform();
		}
		/**
		 * get the position in y axis
		 */
		public function get y():Number {
			return m_worldTransform.position.y;
		}
		
		/**
		 * set the position in z axis
		 */
		public function set z(v:Number):void {
			m_worldTransform.position = new AVector(m_worldTransform.position.x, m_worldTransform.position.y, v);
			updateTransform();
		}
		/**
		 * get the position in z axis
		 */
		public function get z():Number {
			return m_worldTransform.position.z;
		}
		
		/**
		 * set the euler angle in degrees
		 */
		public function set rotation(rot : AVector) : void {
			m_worldTransform.rotation = BulletMath.degrees2radiansV3D(rot);
			updateTransform();
		}
		
		/**
		 * get the euler angle in degrees
		 */
		public function get rotation() : AVector {
			return BulletMath.radians2degreesV3D(m_worldTransform.rotation);
		}
		
		/**
		 * set the angle of x axis in degree
		 */
		public function set rotationX(angle:Number):void {
			m_worldTransform.rotation = new AVector(angle * BulletMath.DEGREES_TO_RADIANS, m_worldTransform.rotation.y, m_worldTransform.rotation.z);
			updateTransform();
		}
		/**
		 * get the angle of x axis in degree
		 */
		public function get rotationX():Number {
			return m_worldTransform.rotation.x * BulletMath.RADIANS_TO_DEGREES;
		}
		
		/**
		 * set the angle of y axis in degree
		 */
		public function set rotationY(angle:Number):void {
			m_worldTransform.rotation = new AVector(m_worldTransform.rotation.x, angle * BulletMath.DEGREES_TO_RADIANS, m_worldTransform.rotation.z);
			updateTransform();
		}
		/**
		 * get the angle of y axis in degree
		 */
		public function get rotationY():Number {
			return m_worldTransform.rotation.y * BulletMath.RADIANS_TO_DEGREES;
		}
		
		/**
		 * set the angle of z axis in degree
		 */
		public function set rotationZ(angle:Number):void {
			m_worldTransform.rotation = new AVector(m_worldTransform.rotation.x, m_worldTransform.rotation.y, angle * BulletMath.DEGREES_TO_RADIANS);
			updateTransform();
		}
		/**
		 * get the angle of z axis in degree
		 */
		public function get rotationZ():Number {
			return m_worldTransform.rotation.z * BulletMath.RADIANS_TO_DEGREES;
		}
		
		/**
		 * set the scaling of collision shape
		 */
		public function set scale(sc:AVector):void {
			m_shape.localScaling = sc;
			updateTransform();
		}
		/**
		 * get the scaling of collision shape
		 */
		public function get scale():AVector {
			return m_shape.localScaling;
		}
		
		/**
		 * set the transform in world coordinates
		 */
		public function set transform(tr:HMatrix) : void {
			m_worldTransform.transform = tr;
			m_shape.localScaling = tr.decompose()[2];
			updateTransform();
		}
		/**
		 * get the transform in world coordinates
		 */
		public function get transform():HMatrix {
			return m_worldTransform.transform;
		}
		
		public function get worldTransform():BulletTransform {
			return m_worldTransform;
		}
		
		/**
		 * get the front direction in world coordinates
		 */
		public function get front():AVector {
			return m_worldTransform.basis.column3;
		}
		/**
		 * get the up direction in world coordinates
		 */
		public function get up():AVector {
			return m_worldTransform.basis.column2;
		}
		/**
		 * get the right direction in world coordinates
		 */
		public function get right():AVector {
			return m_worldTransform.basis.column1;
		}
		
		/**
		 * add a ray in local space
		 */
		public function addRay(from:AVector, to:AVector):void {
			var vec1:BulletVector3 = new BulletVector3();
			vec1.sv3d = from;
			var vec2:BulletVector3 = new BulletVector3();
			vec2.sv3d = to;
			var ptr:uint = addRayInC(pointer, vec1.pointer, vec2.pointer);
			_rays.push(new BulletRay(from, to, ptr));
			
			CModule.free(vec1.pointer);
			CModule.free(vec2.pointer);
		}
		 /**
		  * remove a ray by index
		  */
		public function removeRay(index:uint):void {
			if(index<_rays.length){
				removeRayInC(_rays[index].pointer);
				_rays.splice(index, 1);
			}
		}
		/**
		  * remove all rays in this collision object
		  */
		public function removeAllRays():void {
			while (_rays.length > 0){
				removeRay(0);
			}
			_rays.length = 0;
		}
		
		/**
		 * get all rays
		 */
		public function get rays():Vector.<BulletRay> {
			return _rays;
		}
		
		public function get anisotropicFriction() : AVector {
			return m_anisotropicFriction.v3d;
		}
		
		public function set anisotropicFriction(v : AVector) : void {
			m_anisotropicFriction.v3d = v;
			hasAnisotropicFriction = (v.x != 1 || v.y != 1 || v.z != 1) ? 1 : 0;
		}
		
		public function get friction() : Number {
			return CModule.readFloat(pointer + 224);
		}
		
		public function set friction(v : Number) : void {
			CModule.writeFloat(pointer + 224, v);
		}
		
		public function get rollingFriction() : Number {
			return CModule.readFloat(pointer + 232);
		}
		
		public function set rollingFriction(v : Number) : void {
			CModule.writeFloat(pointer + 232, v);
		}
		
		public function get restitution() : Number {
			return CModule.readFloat(pointer + 228);
		}
		
		public function set restitution(v : Number) : void {
			CModule.writeFloat(pointer + 228, v);
		}
		
		public function get hasAnisotropicFriction() : int {
			return CModule.read32(pointer + 180);
		}
		
		public function set hasAnisotropicFriction(v : int) : void {
			CModule.write32(pointer + 180, v);
		}
		
		public function get contactProcessingThreshold() : Number {
			return CModule.readFloat(pointer + 184);
		}
		
		public function set contactProcessingThreshold(v : Number) : void {
			CModule.writeFloat(pointer + 184, v);
		}
		
		public function get collisionFlags() : int {
			return CModule.read32(pointer + 204);
		}
		
		public function set collisionFlags(v : int) : void {
			CModule.write32(pointer + 204, v);
		}
		
		public function get islandTag() : int {
			return CModule.read32(pointer + 208);
		}
		
		public function set islandTag(v : int) : void {
			CModule.write32(pointer + 208, v);
		}
		
		public function get companionId() : int {
			return CModule.read32(pointer + 212);
		}
		
		public function set companionId(v : int) : void {
			CModule.write32(pointer + 212, v);
		}
		
		public function get deactivationTime() : Number {
			return CModule.readFloat(pointer + 220);
		}
		
		public function set deactivationTime(v : Number) : void {
			CModule.writeFloat(pointer + 220, v);
		}
		
		public function get activationState() : int {
			return CModule.read32(pointer + 216);
		}
		
		public function set activationState(newState : int) : void {
			if (activationState != BulletCollisionObject.DISABLE_DEACTIVATION && activationState != BulletCollisionObject.DISABLE_SIMULATION) {
				CModule.write32(pointer + 216, newState);
			}
		}
		
		public function forceActivationState(newState : int) : void {
			CModule.write32(pointer + 216, newState);
		}
		
		public function activate(forceActivation : Boolean = false) : void {
			if (forceActivation || (collisionFlags != BulletCollisionFlag.STATIC_OBJECT && collisionFlags != BulletCollisionFlag.KINEMATIC_OBJECT )) {
				this.activationState = BulletCollisionObject.ACTIVE_TAG;
				this.deactivationTime = 0;
			}
		}
		
		public function get isActive() : Boolean {
			return (activationState != BulletCollisionObject.ISLAND_SLEEPING && activationState != BulletCollisionObject.DISABLE_SIMULATION);
		}
		
		/**
		 * reserved to distinguish Bullet's btCollisionObject, btRigidBody, btSoftBody, btGhostObject etc.
		 * the values defined by AWPCollisionObjectTypes
		 */
		public function get internalType() : int {
			return CModule.read32(pointer + 236);
		}
		
		public function get hitFraction() : Number {
			return CModule.readFloat(pointer + 244);
		}
		
		public function set hitFraction(v : Number) : void {
			CModule.writeFloat(pointer + 244, v);
		}
		
		public function get ccdSweptSphereRadius() : Number {
			return CModule.readFloat(pointer + 248);
		}
		
		/**
		 * used to motion clamping
		 * refer to http://bulletphysics.org/mediawiki-1.5.8/index.php/Anti_tunneling_by_Motion_Clamping
		 */
		public function set ccdSweptSphereRadius(v : Number) : void {
			CModule.writeFloat(pointer + 248, v);
		}
		
		public function get ccdMotionThreshold() : Number {
			return CModule.readFloat(pointer + 252);
		}
		
		/**
		 * used to motion clamping
		 * refer to http://bulletphysics.org/mediawiki-1.5.8/index.php/Anti_tunneling_by_Motion_Clamping
		 */
		public function set ccdMotionThreshold(v : Number) : void {
			CModule.writeFloat(pointer + 252, v);
		}
		
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			this.collisionFlags |= BulletCollisionFlag.CUSTOM_MATERIAL_CALLBACK;
			_dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function dispatchEvent(evt : Event) : Boolean {
			return _dispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type : String) : Boolean {
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			this.collisionFlags &= (~BulletCollisionFlag.CUSTOM_MATERIAL_CALLBACK);
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type : String) : Boolean {
			return _dispatcher.willTrigger(type);
		}
		
		/**
		 * this function just called by alchemy
		 */
		public function collisionCallback(mpt : uint, obj : BulletCollisionObject) : void {
			var pt : BulletManifoldPoint = new BulletManifoldPoint(mpt);
			var event : BulletEvent = new BulletEvent(BulletEvent.COLLISION_ADDED);
			event.manifoldPoint = pt;
			event.collisionObject = obj;
			
			this.dispatchEvent(event);
		}
		
		/**
		 * this function just called by alchemy
		 */
		public function rayCastCallback(mpt : uint, obj : BulletCollisionObject) : void {
			var pt : BulletManifoldPoint = new BulletManifoldPoint(mpt);
			var event : BulletEvent = new BulletEvent(BulletEvent.RAY_CAST);
			event.manifoldPoint = pt;
			event.collisionObject = obj;
			
			this.dispatchEvent(event);
		}
	}

}