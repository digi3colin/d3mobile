package com.fastframework.module.d3mobile {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	/**
	 * @author Digi3
	 */
	public class CloneSprite {
		private var stage:Stage;
		private var sourceClass:Class;
		private var source:Sprite;
		private var cloneLayer:Sprite;
		private var spDragging:Sprite;
		private var dropArea:Sprite;
		private var clones:Vector.<Sprite>;
		
		public function CloneSprite(source:Sprite,sourceClass:Class,cloneLayer:Sprite,dropArea:Sprite){
			this.clones = new Vector.<Sprite>();
			this.source = source;
			this.sourceClass = sourceClass;
			this.stage = source.stage;
			this.cloneLayer = cloneLayer;
			this.dropArea = dropArea;

			source.addEventListener(Event.REMOVED_FROM_STAGE, kill);
			source.addEventListener(MouseEvent.MOUSE_DOWN, onSourceClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function kill(e:Event):void{
			source.removeEventListener(Event.REMOVED_FROM_STAGE, kill);
			source.removeEventListener(MouseEvent.MOUSE_DOWN, onSourceClick);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			killClones();
			this.stage=null;
			this.source=null;
			this.cloneLayer=null;
			this.spDragging=null;
			this.dropArea = null;
			clones = null;
		}

		private function onSourceClick(e:MouseEvent):void{
			stopSpriteDrag();
			startSpriteDrag(addClone());
		}

		public function killClones():void{
			for(var i:int=0;i<clones.length;i++){
				if(clones[i]==null)continue;
				cloneLayer.removeChild(clones[i]);
				clones[i] = null;
			}
			this.clones = new Vector.<Sprite>();
		}

		public function addClone():Sprite{
			var clone:Sprite = new sourceClass();
			clone.addEventListener(Event.REMOVED_FROM_STAGE, onCloneKill);
            clone.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
            clone.addEventListener(TransformGestureEvent.GESTURE_ROTATE, onRotate);
			clone.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

			clone.transform.matrix = source.transform.matrix.clone();

			clones.push(clone);
			cloneLayer.addChild(clone);
			return clone;
		}

		private function onCloneKill(e:Event):void{
			var clone:Sprite = e.currentTarget as Sprite;
			clone.removeEventListener(Event.REMOVED_FROM_STAGE, onCloneKill);
			clone.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
			clone.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, onRotate);
			clone.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

			for(var i:int=0;i<clones.length;i++){
				if(clones[i]===clone){
					clones[i]=null;
					break;
				}
			}
		}

		/*translate*/
		private function onMouseDown(e:MouseEvent):void
		{
			startSpriteDrag(e.currentTarget as Sprite);
		}

		private function onMouseUp(e:MouseEvent):void
		{ 
			if(spDragging!=null){
				//test sprite out of dropArea
				var isSpriteOutBound:Boolean = !this.dropArea.hitTestPoint(e.stageX, e.stageY,true);
				if(isSpriteOutBound){
					cloneLayer.removeChild(spDragging);
				}
			}
			stopSpriteDrag();
		}

		private function startSpriteDrag(sp:Sprite):void
		{
			sp.startDrag(false);
			spDragging = sp;
			sp.parent.setChildIndex(sp,sp.parent.numChildren - 1);
		}

		private function stopSpriteDrag():void
		{
			if(spDragging==null)return;
			spDragging.stopDrag();
			spDragging = null;
		}

		/*transform*/
        private function onZoom(e:TransformGestureEvent):void
        {
			stopSpriteDrag();

            var sp:Sprite = e.currentTarget as Sprite;
            sp.scaleX *= e.scaleX;
            sp.scaleY *= e.scaleY;

			//limit min size
			if(sp.scaleX<0.3){
				sp.scaleX = sp.scaleY = 0.3;
			}
        }
        
        private function onRotate(e:TransformGestureEvent):void
        {
			stopSpriteDrag();

            var sp:Sprite = e.currentTarget as Sprite;
            sp.rotation += e.rotation;
        }
	}
}
