This is a pop-up description of the object when you hover over it and stop it.
First, you need to initialize the class by passing it the root DisplayObject of your application.
We just write in the main class:
<pre>
<b>BubbleText.init(this);</b>
</pre>
And then we just add the object and its description:
<pre>
<b>var mc:MovieClip = new MovieClip();
addChild(mc);

BubbleText.gi().registerObject(mc, 'It is my movie clip!');</b>
</pre>
