package src.utils 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class BubbleText
	{
		private static const BUBBLE_COLOR:uint = 0xffffcc;
		private static const TIMER_TIME:uint = 700;
		
		private var _bubbleTimeout:uint;
		
		private static var _instance:BubbleText;
		private static var _stage:DisplayObjectContainer;
		
		private var _bubbleObjects:Dictionary = new Dictionary();
		
		private var _textDescription:TextField = new TextField();;
		private var _textSprite:Sprite = new Sprite();
		
		public function BubbleText(itIsSingleton:PrivateSingleton) 
		{
			_textSprite.addChild(_textDescription);
		}
		
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
			_bubbleObjects[object] = {target:object, description:description};
			
			if (!_stage.hasEventListener(MouseEvent.MOUSE_OVER)) 
			{
				_stage.addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler, true);
				_stage.addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler, true);
			}
		}
		
		private function mouseOverOutHandler(event:MouseEvent):void 
		{
			var target:Sprite;
			
			var check_mc:InteractiveObject = event.target as InteractiveObject;
			while (check_mc != event.currentTarget as InteractiveObject) 
			{
				var bubbleObject:Object = _bubbleObjects[check_mc as Sprite];
				if (bubbleObject) 
				{
					target = bubbleObject.target;
					break;
				}
				
				check_mc = check_mc.parent;
			}
			
			if (!target) return;
			
			switch(event.type) 
			{
				case MouseEvent.MOUSE_OVER:
					target.addEventListener(MouseEvent.MOUSE_MOVE, mouseOverOutHandler);
					_bubbleTimeout = setTimeout(displayBubble, TIMER_TIME, target);
					break;
					
				case MouseEvent.MOUSE_MOVE:
					removeBubble();
					_bubbleTimeout = setTimeout(displayBubble, TIMER_TIME, target);
					break;
				
				case MouseEvent.MOUSE_OUT:
					removeBubble();
					target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseOverOutHandler);
					break;
			}
		}
		
		private function removeBubble():void 
		{
			clearTimeout(_bubbleTimeout);
				
			_textSprite.graphics.clear();
			_textDescription.text = '';
			
			if(_stage.getChildByName(_textSprite.name))
				_stage.removeChild(_textSprite);
		}
		
		
		private function displayBubble():void 
		{	
			var target:Sprite = arguments[0];

			_textDescription.defaultTextFormat = new TextFormat('Verdana');
			_textDescription.autoSize = 'center';
			_textDescription.text = _bubbleObjects[target].description;
			_textDescription.x = 0;
			_textDescription.y = 0;
				
			var gap:uint = 10;
			_textSprite.graphics.lineStyle(0, 0, 1, true);
			_textSprite.graphics.beginFill(BUBBLE_COLOR);
			_textSprite.graphics.drawRoundRect(_textDescription.x-gap, _textDescription.y-gap, _textDescription.width+gap*2, _textDescription.height+gap*2, 10);

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
