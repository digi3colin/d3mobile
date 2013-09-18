package com.fastframework.module.d3mobile {
	import flash.display.Sprite;
	/**
	 * @author Digi3Studio - Colin Leung
	 */
	final public class Viewport{
		public var scale:Number=1;
//		public var debug:BitmapData;

		public function Viewport(mc:Sprite){
			scale = mc.scaleX;
//			var debugCanvas:Bitmap = new Bitmap(debug=new BitmapData(768,1024,true,0));
//			debugCanvas.scaleX = debugCanvas.scaleY = 4;
//			mc.addChild(debugCanvas);
		}
	}
}