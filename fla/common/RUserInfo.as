package common
{
   public class RUserInfo
   {
       
      
      public var uid:Number;
      
      public var firstName:String;
      
      public var lastName:String;
      
      public var picsquare:String;
      
      public var picbig:String;
      
      public var level:int;
      
      public var experience:int;
      
      public var points:int;
      
      public var init:Boolean;
      
      public var winratio:int;
      
      public var worldrank:int;
      
      public var driver:int;
      
      public var maps:Array;
      
      public var free:Boolean;
      
      public var fbtime:Number;
      
      public var fbname:String;
      
      public var fbpic:String;
      
      public var fbrank:int;
      
      public var wbtime:Number;
      
      public var wbname:String;
      
      public var wbpic:String;
      
      public var beatrank:int;
      
      public var beatname:String;
      
      public var beatpic:String;
      
      public var mapid:int;
      
      public var isFirstRank:Boolean;
      
      public var coins:int;
      
      public var pfriends:int;
      
      public var fcoins:int;
      
      public var nextfriends:int;
      
      public var nextcoins:int;
      
      public var races:int;
      
      public var level1time:String;
      
      public var level2time:String;
      
      public var level3time:String;
      
      public var level4time:String;
      
      public var level5time:String;
      
      public function RUserInfo()
      {
         this.level1time = new String();
         this.level2time = new String();
         this.level3time = new String();
         this.level4time = new String();
         this.level5time = new String();
         super();
      }
   }
}
