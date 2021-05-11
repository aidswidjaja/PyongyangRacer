package player
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class RSoundMgr
   {
      
      public static var m_Sound:Object;
      
      public static var m_GameSWfLoader:Loader;
       
      
      public function RSoundMgr()
      {
         super();
      }
      
      public static function LoadSWF(param1:String) : void
      {
         m_GameSWfLoader = new Loader();
         m_Sound = new Dictionary(true);
         var _loc2_:URLRequest = new URLRequest(RockRacer.base + param1);
         var _loc3_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         m_GameSWfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onSWFLoadComplete);
         m_GameSWfLoader.load(_loc2_,_loc3_);
      }
      
      protected static function onSWFLoadComplete(param1:Event) : void
      {
         var _loc2_:Class = GetClassInSWF("engine");
         var _loc3_:Sound = Sound(new _loc2_());
         m_Sound["engine"] = _loc3_;
         _loc2_ = GetClassInSWF("engine_start");
         _loc3_ = Sound(new _loc2_());
         m_Sound["engine_start"] = _loc3_;
         _loc2_ = GetClassInSWF("engine_accel");
         _loc3_ = Sound(new _loc2_());
         m_Sound["engine_accel"] = _loc3_;
         _loc2_ = GetClassInSWF("engine_down");
         _loc3_ = Sound(new _loc2_());
         m_Sound["engine_down"] = _loc3_;
         _loc2_ = GetClassInSWF("win");
         _loc3_ = Sound(new _loc2_());
         m_Sound["win"] = _loc3_;
         _loc2_ = GetClassInSWF("fail");
         _loc3_ = Sound(new _loc2_());
         m_Sound["fail"] = _loc3_;
         _loc2_ = GetClassInSWF("InGame");
         _loc3_ = Sound(new _loc2_());
         m_Sound["InGame"] = _loc3_;
         _loc2_ = GetClassInSWF("accelboard");
         _loc3_ = Sound(new _loc2_());
         m_Sound["accelboard"] = _loc3_;
         _loc2_ = GetClassInSWF("beaten");
         _loc3_ = Sound(new _loc2_());
         m_Sound["beaten"] = _loc3_;
         _loc2_ = GetClassInSWF("booster");
         _loc3_ = Sound(new _loc2_());
         m_Sound["booster"] = _loc3_;
         _loc2_ = GetClassInSWF("brake");
         _loc3_ = Sound(new _loc2_());
         m_Sound["brake"] = _loc3_;
         _loc2_ = GetClassInSWF("collision_car");
         _loc3_ = Sound(new _loc2_());
         m_Sound["collision_car"] = _loc3_;
         _loc2_ = GetClassInSWF("collision_fake");
         _loc3_ = Sound(new _loc2_());
         m_Sound["collision_fake"] = _loc3_;
         _loc2_ = GetClassInSWF("collision_item");
         _loc3_ = Sound(new _loc2_());
         m_Sound["collision_item"] = _loc3_;
         _loc2_ = GetClassInSWF("grass");
         _loc3_ = Sound(new _loc2_());
         m_Sound["grass"] = _loc3_;
         _loc2_ = GetClassInSWF("fire_item");
         _loc3_ = Sound(new _loc2_());
         m_Sound["fire_item"] = _loc3_;
         _loc2_ = GetClassInSWF("honk");
         _loc3_ = Sound(new _loc2_());
         m_Sound["honk"] = _loc3_;
         _loc2_ = GetClassInSWF("lay_item");
         _loc3_ = Sound(new _loc2_());
         m_Sound["lay_item"] = _loc3_;
         _loc2_ = GetClassInSWF("light_beaten");
         _loc3_ = Sound(new _loc2_());
         m_Sound["light_beaten"] = _loc3_;
         _loc2_ = GetClassInSWF("oil");
         _loc3_ = Sound(new _loc2_());
         m_Sound["oil"] = _loc3_;
         _loc2_ = GetClassInSWF("passlap");
         _loc3_ = Sound(new _loc2_());
         m_Sound["passlap"] = _loc3_;
         _loc2_ = GetClassInSWF("shield1");
         _loc3_ = Sound(new _loc2_());
         m_Sound["shield1"] = _loc3_;
         _loc2_ = GetClassInSWF("autopilot");
         _loc3_ = Sound(new _loc2_());
         m_Sound["autopilot"] = _loc3_;
         _loc2_ = GetClassInSWF("light_beaten");
         _loc3_ = Sound(new _loc2_());
         m_Sound["light_beaten"] = _loc3_;
         _loc2_ = GetClassInSWF("collision_wall");
         _loc3_ = Sound(new _loc2_());
         m_Sound["collision_wall"] = _loc3_;
         _loc2_ = GetClassInSWF("selectweapon");
         _loc3_ = Sound(new _loc2_());
         m_Sound["selectweapon"] = _loc3_;
         _loc2_ = GetClassInSWF("go");
         _loc3_ = Sound(new _loc2_());
         m_Sound["go"] = _loc3_;
         _loc2_ = GetClassInSWF("mud_beaten");
         _loc3_ = Sound(new _loc2_());
         m_Sound["mud_beaten"] = _loc3_;
         _loc2_ = GetClassInSWF("whistle");
         _loc3_ = Sound(new _loc2_());
         m_Sound["whistle"] = _loc3_;
      }
      
      protected static function GetClassInSWF(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
      
      public static function GetSound(param1:String) : Sound
      {
         return m_Sound[param1];
      }
   }
}
