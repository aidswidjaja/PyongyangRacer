package it.gotoandplay.smartfoxserver.data
{
   public class Room
   {
       
      
      private var id:int;
      
      private var name:String;
      
      private var maxUsers:int;
      
      private var maxSpectators:int;
      
      private var temp:Boolean;
      
      private var game:Boolean;
      
      private var priv:Boolean;
      
      private var limbo:Boolean;
      
      private var userCount:int;
      
      private var specCount:int;
      
      private var myPlayerIndex:int;
      
      private var userList:Array;
      
      private var variables:Array;
      
      public function Room(param1:int, param2:String, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:int = 0, param10:int = 0)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.maxSpectators = param4;
         this.maxUsers = param3;
         this.temp = param5;
         this.game = param6;
         this.priv = param7;
         this.limbo = param8;
         this.userCount = param9;
         this.specCount = param10;
         this.userList = [];
         this.variables = [];
      }
      
      public function addUser(param1:User, param2:int) : void
      {
         this.userList[param2] = param1;
         if(this.game && param1.isSpectator())
         {
            ++this.specCount;
         }
         else
         {
            ++this.userCount;
         }
      }
      
      public function removeUser(param1:int) : void
      {
         var _loc2_:User = this.userList[param1];
         if(this.game && _loc2_.isSpectator())
         {
            --this.specCount;
         }
         else
         {
            --this.userCount;
         }
         delete this.userList[param1];
      }
      
      public function getUserList() : Array
      {
         return this.userList;
      }
      
      public function getUser(param1:*) : User
      {
         var _loc3_:* = null;
         var _loc4_:User = null;
         var _loc2_:User = null;
         if(typeof param1 == "number")
         {
            _loc2_ = this.userList[param1];
         }
         else if(typeof param1 == "string")
         {
            for(_loc3_ in this.userList)
            {
               if((_loc4_ = this.userList[_loc3_]).getName() == param1)
               {
                  _loc2_ = _loc4_;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public function clearUserList() : void
      {
         this.userList = [];
         this.userCount = 0;
         this.specCount = 0;
      }
      
      public function getVariable(param1:String) : *
      {
         return this.variables[param1];
      }
      
      public function getVariables() : Array
      {
         return this.variables;
      }
      
      public function setVariables(param1:Array) : void
      {
         this.variables = param1;
      }
      
      public function clearVariables() : void
      {
         this.variables = [];
      }
      
      public function getName() : String
      {
         return this.name;
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function isTemp() : Boolean
      {
         return this.temp;
      }
      
      public function isGame() : Boolean
      {
         return this.game;
      }
      
      public function isPrivate() : Boolean
      {
         return this.priv;
      }
      
      public function getUserCount() : int
      {
         return this.userCount;
      }
      
      public function getSpectatorCount() : int
      {
         return this.specCount;
      }
      
      public function getMaxUsers() : int
      {
         return this.maxUsers;
      }
      
      public function getMaxSpectators() : int
      {
         return this.maxSpectators;
      }
      
      public function setMyPlayerIndex(param1:int) : void
      {
         this.myPlayerIndex = param1;
      }
      
      public function getMyPlayerIndex() : int
      {
         return this.myPlayerIndex;
      }
      
      public function setIsLimbo(param1:Boolean) : void
      {
         this.limbo = param1;
      }
      
      public function isLimbo() : Boolean
      {
         return this.limbo;
      }
      
      public function setUserCount(param1:int) : void
      {
         this.userCount = param1;
      }
      
      public function setSpectatorCount(param1:int) : void
      {
         this.specCount = param1;
      }
   }
}
