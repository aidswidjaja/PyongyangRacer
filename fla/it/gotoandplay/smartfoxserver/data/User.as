package it.gotoandplay.smartfoxserver.data
{
   public class User
   {
       
      
      private var id:int;
      
      private var name:String;
      
      private var variables:Array;
      
      private var isSpec:Boolean;
      
      private var isMod:Boolean;
      
      private var pId:int;
      
      public function User(param1:int, param2:String)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.variables = [];
         this.isSpec = false;
         this.isMod = false;
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function getName() : String
      {
         return this.name;
      }
      
      public function getVariable(param1:String) : *
      {
         return this.variables[param1];
      }
      
      public function getVariables() : Array
      {
         return this.variables;
      }
      
      public function setVariables(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = undefined;
         for(_loc2_ in param1)
         {
            _loc3_ = param1[_loc2_];
            if(_loc3_ != null)
            {
               this.variables[_loc2_] = _loc3_;
            }
            else
            {
               delete this.variables[_loc2_];
            }
         }
      }
      
      public function clearVariables() : void
      {
         this.variables = [];
      }
      
      public function setIsSpectator(param1:Boolean) : void
      {
         this.isSpec = param1;
      }
      
      public function isSpectator() : Boolean
      {
         return this.isSpec;
      }
      
      public function setModerator(param1:Boolean) : void
      {
         this.isMod = param1;
      }
      
      public function isModerator() : Boolean
      {
         return this.isMod;
      }
      
      public function getPlayerId() : int
      {
         return this.pId;
      }
      
      public function setPlayerId(param1:int) : void
      {
         this.pId = param1;
      }
   }
}
