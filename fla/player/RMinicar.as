package player
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   
   public class RMinicar extends Sprite
   {
      
      public static const TYPE_DUCK:String = "duck";
      
      public static const TYPE_MAN:String = "man";
      
      public static const TYPE_WOMAN:String = "woman";
      
      public static const TYPE_ELEPHANT:String = "elephant";
      
      public static const TYPE_PYCAR:String = "PYcar";
       
      
      public var character:MovieClip;
      
      public function RMinicar(param1:String)
      {
         var _loc2_:Class = null;
         var _loc3_:Class = null;
         var _loc4_:Class = null;
         var _loc5_:Class = null;
         var _loc6_:Class = null;
         super();
         switch(param1)
         {
            case TYPE_PYCAR:
               _loc2_ = getDefinitionByName(TYPE_PYCAR) as Class;
               this.character = MovieClip(new _loc2_());
               this.character.x = 0;
               this.character.y = 0;
               this.addChild(this.character);
               this.character.gotoAndStop(0);
               break;
            case TYPE_DUCK:
               _loc3_ = getDefinitionByName(TYPE_DUCK) as Class;
               this.character = MovieClip(new _loc3_());
               this.character.x = 10;
               this.character.y = 10;
               this.addChild(this.character);
               this.character.gotoAndStop(0);
               break;
            case TYPE_MAN:
               _loc4_ = getDefinitionByName(TYPE_MAN) as Class;
               this.character = MovieClip(new _loc4_());
               this.character.x = 10;
               this.character.y = 10;
               this.addChild(this.character);
               this.character.gotoAndStop(0);
               break;
            case TYPE_WOMAN:
               _loc5_ = getDefinitionByName(TYPE_WOMAN) as Class;
               this.character = MovieClip(new _loc5_());
               this.character.x = 10;
               this.character.y = 10;
               this.addChild(this.character);
               this.character.gotoAndStop(0);
               break;
            case TYPE_ELEPHANT:
               _loc6_ = getDefinitionByName(TYPE_ELEPHANT) as Class;
               this.character = MovieClip(new _loc6_());
               this.character.x = 10;
               this.character.y = 10;
               this.addChild(this.character);
               this.character.gotoAndStop(0);
         }
      }
   }
}
