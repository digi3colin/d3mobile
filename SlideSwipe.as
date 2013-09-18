package com.fastframework.module.d3mobile {
	import com.fastframework.core.FASTEventDispatcher;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;

	/**
	 * @author Digi3Studio - Colin Leung
	 */
	public class SlideSwipe extends FASTEventDispatcher {
		public static const EVENT_SWIPE_LEFT:String 	= "EVENT_SWIPE_LEFT";
		public static const EVENT_SWIPE_RIGHT:String 	= "EVENT_SWIPE_RIGHT";
		public static const EVENT_SWIPE_TOP:String 		= "EVENT_SWIPE_TOP";
		public static const EVENT_SWIPE_BOTTOM:String 	= "EVENT_SWIPE_BOTTOM";

		private var enableTop:Boolean = true;
		private var enableLeft:Boolean = true;
		private var enableBottom:Boolean= true;
		private var enableRight:Boolean = true;

		public function SlideSwipe(stage:Stage) {
			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
		}

		public function setEnable(top:Boolean,left:Boolean,bottom:Boolean,right:Boolean):void{
			this.enableTop = top;
			this.enableLeft = left;
			this.enableBottom = bottom;
			this.enableRight = right;
		}

		private function onSwipe(e:TransformGestureEvent):void{
			if(e.offsetX==1){
				if(this.enableRight==false)return;
				dispatchEvent(new Event(SlideSwipe.EVENT_SWIPE_RIGHT,false,true));
			}
			if(e.offsetX==-1){
				if(this.enableLeft==false)return;
				dispatchEvent(new Event(SlideSwipe.EVENT_SWIPE_LEFT,false,true));
			}
			if(e.offsetY==1){
				if(this.enableBottom==false)return;
				dispatchEvent(new Event(SlideSwipe.EVENT_SWIPE_BOTTOM,false,true));
			}
			if(e.offsetY==-1){
				if(this.enableTop==false)return;
				dispatchEvent(new Event(SlideSwipe.EVENT_SWIPE_TOP,false,true));
			}
		}
	}
}