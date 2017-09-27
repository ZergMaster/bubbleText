package src.utils 
{
	import com.greensock.TweenLite;
	import fl.controls.TextArea;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class BubbleText extends Sprite
	{
		private static const BUBBLE_COLOR:uint = 0xffffcc;
		
		private var _bubbleTimeout:uint;
		
		private static var _instance:BubbleText;
		private static var _stage:DisplayObjectContainer;
		
		
		private var _bubbleObjects:Dictionary = new Dictionary();
		
		private var _textDescription:TextField;
		private var _textSprite:Sprite
		
		public function BubbleText(itIsSingleton:PrivateSingleton);
		
		public static function gi():BubbleText 
		{
			if (!_instance)
				_instance = new BubbleText(new PrivateSingleton());
				
			return _instance;
		}
		
		public static function init(s:DisplayObjectContainer):void 
		{
			_stage = s;
		}
		
		
		public function registerObject(object:Sprite, description:String):void 
		{
			_bubbleObjects[object] = description;
			
			if (!object.hasEventListener(MouseEvent.MOUSE_OVER)) 
			{
				object.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
				object.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
				object.mouseChildren = false;
			}
		}
		
		private function mouseOverOutHandler(event:MouseEvent):void 
		{
			var target:Sprite = event.currentTarget as Sprite;
			if (event.type == MouseEvent.MOUSE_OVER) 
			{
				target.addEventListener(MouseEvent.MOUSE_MOVE, mouseOverOutHandler);
				_bubbleTimeout = setTimeout(displayBubble, 700, target);
			}
			
			if(event.type == MouseEvent.MOUSE_MOVE)
			{
				removeBubble();
				_bubbleTimeout = setTimeout(displayBubble, 500, target);
			}
			
			if (event.type == MouseEvent.MOUSE_OUT) 
			{
				removeBubble();
				target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseOverOutHandler);
			}
		}
		
		private function removeBubble():void 
		{
			clearTimeout(_bubbleTimeout);
				
			if (_textSprite) 
				{
					_stage.removeChild(_textSprite);
					_textSprite = null;
				}
		}
		
		
		private function displayBubble():void 
		{	
			_textSprite = new Sprite();
			
			var target:Sprite = arguments[0];
				
			_textDescription = new TextField();
			_textDescription.defaultTextFormat = new TextFormat('Verdana');
			_textDescription.autoSize = 'center';
			_textDescription.text = _bubbleObjects[target];
			_textDescription.x = 0;
			_textDescription.y = 0;
				
			var gap:uint = 10;
			_textSprite.graphics.lineStyle(0, 0, 1, true);
			_textSprite.graphics.beginFill(BUBBLE_COLOR);
			_textSprite.graphics.drawRoundRect(_textDescription.x-gap, _textDescription.y-gap, _textDescription.width+gap*2, _textDescription.height+gap*2, 10);
				
			_textSprite.addChild(_textDescription);
			_textSprite.x = _stage.mouseX;
			_textSprite.y = _stage.mouseY + 40;
			
			if ((_textSprite.x + _textSprite.width) > _stage.stage.stageWidth)
			   _textSprite.x = _stage.mouseX - _textSprite.width + 30
			   
			if ((_textSprite.y + _textSprite.height) > _stage.stage.stageHeight)
			   _textSprite.y = _stage.mouseY - _textSprite.height// + 30
			   
			_stage.addChild(_textSprite);
			_textSprite.alpha = 0;
			
			TweenLite.to(_textSprite, 0.5, {alpha:1});
		}
	}
}

class PrivateSingleton
{
	public function PrivateSingleton() {}
}
