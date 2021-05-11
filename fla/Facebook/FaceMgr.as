package Facebook
{
   import com.adobe.serialization.json.JSON;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.rpc.events.*;
   import mx.rpc.http.HTTPService;
   
   public class FaceMgr extends EventDispatcher
   {
      
      private static var m_plGateway:HTTPService;
      
      private static var m_GameName:String;
      
      private static var m_userId:String;
      
      private static var m_sessionId:String;
      
      private static var m_platform:String;
      
      private static var m_userInfo:Object;
      
      private static var m_friends:Array;
      
      private static var m_worlds:Array;
      
      private static var m_Maps:Array;
      
      private static var m_Driver:Object;
      
      private static var m_FriendInfo:Object;
      
      private static var m_getUsers:Array;
      
      private static var m_teamNumber:int;
      
      private static var m_teamPoint:int = 0;
      
      private static var m_SaveInfo:Object;
      
      public static var waitResult:int = 0;
      
      public static var myRank:int = 1;
       
      
      public var m_UseFriendCall:Boolean = false;
      
      public var m_UseWorldCall:Boolean = false;
      
      public var m_UseGetUsers:Boolean = false;
      
      public var m_UserRank:int = 0;
      
      public function FaceMgr()
      {
         super();
         m_GameName = "Racer";
         this.Initialize();
      }
      
      public static function get userId() : String
      {
         return m_userId;
      }
      
      public static function get friends() : Array
      {
         return m_friends;
      }
      
      public static function get worlds() : Array
      {
         return m_worlds;
      }
      
      public static function get friendInfo() : Object
      {
         return m_FriendInfo;
      }
      
      public static function get mapInfo() : Array
      {
         return m_Maps;
      }
      
      public static function get Users() : Array
      {
         return m_getUsers;
      }
      
      public static function get Teamcount() : int
      {
         if(myRank > m_friends.length)
         {
            return 0;
         }
         return m_friends[myRank - 1].teammates;
      }
      
      public static function get TeamPoint() : int
      {
         if(myRank > m_friends.length)
         {
            return 0;
         }
         return m_friends[myRank - 1].teampoints;
      }
      
      public function Initialize() : void
      {
         m_plGateway = new HTTPService();
         with(m_plGateway)
         {
            resultFormat = "text";
            addEventListener(ResultEvent.RESULT,onHTTPResult);
            addEventListener(FaultEvent.FAULT,onHTTPFault);
         }
         var parameters:Object = RockRacer.parameters;
         if(parameters)
         {
            if(parameters.fb_sig_session_key)
            {
               m_sessionId = parameters.fb_sig_session_key;
            }
            else
            {
               m_sessionId = "0";
            }
            if(parameters.fb_sig_user)
            {
               m_userId = parameters.fb_sig_user;
            }
            else
            {
               m_userId = "100200301";
            }
            if(parameters.platform)
            {
               m_platform = parameters.platform;
            }
            else
            {
               m_platform = "fb";
            }
            m_plGateway.url = RockRacer.GameCommon.GetTextFunc("$GATEWAY_URL");
            this.sendMessage({"func":"logUser"});
            this.sendMessage({"func":"getFriendDetails"});
            this.sendMessage({"func":"getMaps"});
         }
      }
      
      public function UpdateData() : void
      {
         this.sendMessage({"func":"logUser"});
         this.sendMessage({"func":"getFriendRanking"});
         this.sendMessage({"func":"getMaps"});
      }
      
      private function onHTTPResult(param1:Object) : void
      {
         var i:int = 0;
         var k:int = 0;
         var event:Object = param1;
         var _func:String = event.func;
         try
         {
            switch(_func)
            {
               case "logUser":
                  m_userInfo = com.adobe.serialization.json.JSON.decode("{\"uid\":100200301, \"firstname\":\"Thorsten\", \"lastname\":\"Lubinski\",\"picsquare\":\"\",\t\"picbig\":\"\",\t\"level\":1,\"experience\":20,\"points\":300,\"init\":false,\"winratio\":70,\"worldrank\":2,\"driver\":0,\"maps\":[{\"mapid\":1010, \"personalbest\":550, \"free\":true},\t{\"mapid\":1020, \"personalbest\":525, \"free\":true},{\"mapid\":1030, \"personalbest\":0, \"free\":false},\t{\"mapid\":1040, \"personalbest\":0, \"free\":false},\t{\"mapid\":1050, \"personalbest\":0, \"free\":false},\t{\"mapid\":1060, \"personalbest\":0, \"free\":false}],\"coins\":700,\"pfriends\":20,\"fcoins\":600,\"nextfriends\":3,\t\"nextcoins\":1000,\"level1time\":\"3:50\",\"level2time\":\"4:11\",\"level3time\":\"4:23\",\"level4time\":\"4:31\",\"level5time\":\"5:01\",\"races\":10}");
                  break;
               case "getFriendRanking":
                  m_friends = com.adobe.serialization.json.JSON.decode("[{\"firstname\":\"Volker\",\"lastname\":\"Eloesser\",\"locale\":\"de_DE\",\"picsquare\":\"\",\"picbig\":\"\",\"uid\":\"1526476494\",\"points\":\"429\",\"teammates\":\"0\",\"teampoints\":\"0\"}]");
                  i = 0;
                  while(i < m_friends.length)
                  {
                     m_friends[i].totalpoint = int(m_friends[i].points) * 2 + int(m_friends[i].teampoints);
                     i++;
                  }
                  m_friends.sortOn("totalpoint",Array.NUMERIC | Array.DESCENDING);
                  i = 0;
                  while(i < m_friends.length)
                  {
                     if(int(m_userId) == int(m_friends[i].uid))
                     {
                        myRank = i + 1;
                        break;
                     }
                     i++;
                  }
                  dispatchEvent(new Event("EmptyFriendCall"));
                  break;
               case "getFriendDetails":
                  m_FriendInfo = com.adobe.serialization.json.JSON.decode("{\"uid\":100200300,\t\t\t\t\"firstname\":\"Volker\",\t\t\t\t\"lastname\":\"Eloesser\",\t\t\t\t\"picsquare\":\"\",\t\t\t\t\"picbig\":\"\",\t\t\t\t\"level\":2,\t\t\t\t\"experience\":20,\t\t\t\t\"points\":429,\t\t\t\t\"winratio\":70,\t\t\t\t\"worldrank\":10,\t\t\t\t\"driver\":1,\t\t\t\t\"maps\":[{\"mapid\":1010, \"personalbest\":150},\t\t\t\t\t\t{\"mapid\":1020, \"personalbest\":125},\t\t\t\t\t\t{\"mapid\":1030, \"personalbest\":0},\t\t\t\t\t\t{\"mapid\":1040, \"personalbest\":0},\t\t\t\t\t\t{\"mapid\":1050, \"personalbest\":0},\t\t\t\t\t\t{\"mapid\":1060, \"personalbest\":0}],\t\t\t\t\"races\":10\t\t\t\t}");
                  break;
               case "getMaps":
                  m_Maps = com.adobe.serialization.json.JSON.decode("[{\"mapid\":1010,\"free\":true,\"fbtime\":123,\"fbname\":\"Volker\",\"fbpic\":\"\",\"wbtime\":122,\"wbname\":\"Kim_ci\",\"wbpic\":\"\",\"beatrank\":2,\"beatname\":\"Volker\",\"beatpic\":\"\"}]");
                  break;
               case "getFriends":
                  m_getUsers = com.adobe.serialization.json.JSON.decode("[{\"uid\":\"26447\",\"picbig\":\"\",\"firstname\":\"Alexander\",\"lastname\":\"Samwer\"}]");
                  k = m_getUsers.length - 1;
                  while(k >= 0)
                  {
                     m_getUsers[k].firstname = m_getUsers[k].firstname.toLowerCase();
                     k--;
                  }
                  dispatchEvent(new Event("EmptyUsersCall"));
                  break;
               case "saveGame":
            }
         }
         catch(e:Error)
         {
            trace(e);
         }
         dispatchEvent(new Event(_func));
         --waitResult;
      }
      
      private function onHTTPFault(param1:FaultEvent) : void
      {
         trace("Http Fault");
      }
      
      private function sendMessage(param1:Object) : void
      {
         param1.game = m_GameName;
         param1.userid = m_userId;
         param1.sessid = m_sessionId;
         param1.platform = m_platform;
         ++waitResult;
         trace("param = " + param1.m_sessionId + "   " + param1.userid);
         this.onHTTPResult(param1);
      }
      
      public function getUsers(param1:Function = null) : void
      {
         if(!this.m_UseGetUsers)
         {
            this.sendMessage({"func":"getFriends"});
            this.m_UseGetUsers = true;
            if(param1 != null)
            {
               this.addEventListener("getFriends",param1);
            }
         }
         else
         {
            if(param1 != null)
            {
               this.addEventListener("EmptyUsersCall",param1);
            }
            if(m_getUsers)
            {
               dispatchEvent(new Event("EmptyUsersCall"));
            }
         }
      }
      
      public function getFriends(param1:Function = null) : void
      {
         if(!this.m_UseFriendCall)
         {
            this.sendMessage({"func":"getFriendRanking"});
            this.m_UseFriendCall = true;
            if(param1 != null)
            {
               this.addEventListener("getFriendRanking",param1);
            }
         }
         else
         {
            if(param1 != null)
            {
               this.addEventListener("EmptyFriendCall",param1);
            }
            if(m_friends)
            {
               dispatchEvent(new Event("EmptyFriendCall"));
            }
         }
      }
      
      public function getFriendInfo(param1:String, param2:Function = null) : void
      {
         this.sendMessage({
            "userid":m_userId,
            "playerid":param1,
            "func":"getFriendDetails"
         });
         if(param2 != null)
         {
            this.addEventListener("getFriendDetails",param2);
         }
      }
      
      public function getMap(param1:Function = null) : void
      {
         this.sendMessage({"func":"getMaps"});
         if(param1 != null)
         {
            this.addEventListener("getMaps",param1);
         }
      }
      
      public function changeDriver(param1:int, param2:Function = null) : void
      {
         this.sendMessage({
            "driver":param1,
            "func":"changeDriver"
         });
         if(param2 != null)
         {
            this.addEventListener("changeDriver",param2);
         }
      }
      
      public function SaveGame(param1:int, param2:int, param3:int, param4:Function = null) : void
      {
         this.sendMessage({
            "mapID":param1,
            "time":param2,
            "rank":param3,
            "func":"saveGame"
         });
      }
      
      public function user() : Object
      {
         if(m_userInfo)
         {
            return m_userInfo;
         }
         return null;
      }
   }
}
