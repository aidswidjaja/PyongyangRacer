package org.papervision3d.core.render.data
{
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import org.papervision3d.core.render.command.RenderableListItem;
   import org.papervision3d.objects.DisplayObject3D;
   
   public final class QuadTreeNode
   {
       
      
      private var render_center_length:int = -1;
      
      private var render_center_index:int = -1;
      
      private var halfwidth:Number;
      
      private var halfheight:Number;
      
      private var level:int;
      
      public var maxlevel:int = 4;
      
      public var center:Array;
      
      public var lefttop:QuadTreeNode;
      
      public var leftbottom:QuadTreeNode;
      
      public var righttop:QuadTreeNode;
      
      public var rightbottom:QuadTreeNode;
      
      public var lefttopFlag:Boolean;
      
      public var leftbottomFlag:Boolean;
      
      public var righttopFlag:Boolean;
      
      public var rightbottomFlag:Boolean;
      
      public var onlysourceFlag:Boolean = true;
      
      public var onlysource:DisplayObject3D;
      
      public var xdiv:Number;
      
      public var ydiv:Number;
      
      public var parent:QuadTreeNode;
      
      public var create:Function;
      
      public var hasContent:Boolean = false;
      
      public function QuadTreeNode(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:QuadTreeNode = null, param7:uint = 4)
      {
         super();
         this.level = param5;
         this.xdiv = param1;
         this.ydiv = param2;
         this.halfwidth = param3 / 2;
         this.halfheight = param4 / 2;
         this.parent = param6;
         this.maxlevel = param7;
      }
      
      private function render_other(param1:Number, param2:RenderSessionData, param3:Graphics) : void
      {
         if(this.lefttopFlag)
         {
            this.lefttop.render(param1,param2,param3);
         }
         if(this.leftbottomFlag)
         {
            this.leftbottom.render(param1,param2,param3);
         }
         if(this.righttopFlag)
         {
            this.righttop.render(param1,param2,param3);
         }
         if(this.rightbottomFlag)
         {
            this.rightbottom.render(param1,param2,param3);
         }
      }
      
      public function push(param1:RenderableListItem) : void
      {
         this.hasContent = true;
         if(this.onlysourceFlag)
         {
            if(this.onlysource != null && this.onlysource != param1.instance)
            {
               this.onlysourceFlag = false;
            }
            this.onlysource = param1.instance;
         }
         if(this.level < this.maxlevel)
         {
            if(param1.maxX <= this.xdiv)
            {
               if(param1.maxY <= this.ydiv)
               {
                  if(this.lefttop == null)
                  {
                     this.lefttopFlag = true;
                     this.lefttop = new QuadTreeNode(this.xdiv - this.halfwidth / 2,this.ydiv - this.halfheight / 2,this.halfwidth,this.halfheight,this.level + 1,this,this.maxlevel);
                  }
                  else if(!this.lefttopFlag)
                  {
                     this.lefttopFlag = true;
                     this.lefttop.reset(this.xdiv - this.halfwidth / 2,this.ydiv - this.halfheight / 2,this.halfwidth,this.halfheight,this.maxlevel);
                  }
                  this.lefttop.push(param1);
                  return;
               }
               if(param1.minY >= this.ydiv)
               {
                  if(this.leftbottom == null)
                  {
                     this.leftbottomFlag = true;
                     this.leftbottom = new QuadTreeNode(this.xdiv - this.halfwidth / 2,this.ydiv + this.halfheight / 2,this.halfwidth,this.halfheight,this.level + 1,this,this.maxlevel);
                  }
                  else if(!this.leftbottomFlag)
                  {
                     this.leftbottomFlag = true;
                     this.leftbottom.reset(this.xdiv - this.halfwidth / 2,this.ydiv + this.halfheight / 2,this.halfwidth,this.halfheight,this.maxlevel);
                  }
                  this.leftbottom.push(param1);
                  return;
               }
            }
            else if(param1.minX >= this.xdiv)
            {
               if(param1.maxY <= this.ydiv)
               {
                  if(this.righttop == null)
                  {
                     this.righttopFlag = true;
                     this.righttop = new QuadTreeNode(this.xdiv + this.halfwidth / 2,this.ydiv - this.halfheight / 2,this.halfwidth,this.halfheight,this.level + 1,this,this.maxlevel);
                  }
                  else if(!this.righttopFlag)
                  {
                     this.righttopFlag = true;
                     this.righttop.reset(this.xdiv + this.halfwidth / 2,this.ydiv - this.halfheight / 2,this.halfwidth,this.halfheight,this.maxlevel);
                  }
                  this.righttop.push(param1);
                  return;
               }
               if(param1.minY >= this.ydiv)
               {
                  if(this.rightbottom == null)
                  {
                     this.rightbottomFlag = true;
                     this.rightbottom = new QuadTreeNode(this.xdiv + this.halfwidth / 2,this.ydiv + this.halfheight / 2,this.halfwidth,this.halfheight,this.level + 1,this,this.maxlevel);
                  }
                  else if(!this.rightbottomFlag)
                  {
                     this.rightbottomFlag = true;
                     this.rightbottom.reset(this.xdiv + this.halfwidth / 2,this.ydiv + this.halfheight / 2,this.halfwidth,this.halfheight,this.maxlevel);
                  }
                  this.rightbottom.push(param1);
                  return;
               }
            }
         }
         if(this.center == null)
         {
            this.center = new Array();
         }
         this.center.push(param1);
         param1.quadrant = this;
      }
      
      public function reset(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint) : void
      {
         this.xdiv = param1;
         this.ydiv = param2;
         this.halfwidth = param3 / 2;
         this.halfheight = param4 / 2;
         this.lefttopFlag = false;
         this.leftbottomFlag = false;
         this.righttopFlag = false;
         this.rightbottomFlag = false;
         this.onlysourceFlag = true;
         this.onlysource = null;
         this.render_center_length = -1;
         this.render_center_index = -1;
         this.hasContent = false;
         this.maxlevel = param5;
      }
      
      public function getRect() : Rectangle
      {
         return new Rectangle(this.xdiv,this.ydiv,this.halfwidth * 2,this.halfheight * 2);
      }
      
      public function render(param1:Number, param2:RenderSessionData, param3:Graphics) : void
      {
         var _loc4_:RenderableListItem = null;
         if(this.render_center_length == -1)
         {
            if(this.center != null)
            {
               this.render_center_length = this.center.length;
               if(this.render_center_length > 1)
               {
                  this.center.sortOn("screenZ",Array.DESCENDING | Array.NUMERIC);
               }
            }
            else
            {
               this.render_center_length = 0;
            }
            this.render_center_index = 0;
         }
         while(this.render_center_index < this.render_center_length)
         {
            if((_loc4_ = this.center[this.render_center_index]).screenZ < param1)
            {
               break;
            }
            this.render_other(_loc4_.screenZ,param2,param3);
            _loc4_.render(param2,param3);
            param2.viewPort.lastRenderList.push(_loc4_);
            ++this.render_center_index;
         }
         if(this.render_center_index == this.render_center_length)
         {
            this.center = null;
         }
         this.render_other(param1,param2,param3);
      }
   }
}
