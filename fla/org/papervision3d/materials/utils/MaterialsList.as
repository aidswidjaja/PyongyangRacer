package org.papervision3d.materials.utils
{
   import flash.utils.Dictionary;
   import org.papervision3d.core.proto.MaterialObject3D;
   
   public class MaterialsList
   {
       
      
      protected var _materials:Dictionary;
      
      private var _materialsTotal:int;
      
      public var materialsByName:Dictionary;
      
      public function MaterialsList(param1:* = null)
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         super();
         this.materialsByName = new Dictionary(true);
         this._materials = new Dictionary(false);
         this._materialsTotal = 0;
         if(param1)
         {
            if(param1 is Array)
            {
               for(_loc2_ in param1)
               {
                  this.addMaterial(param1[_loc2_]);
               }
            }
            else if(param1 is Object)
            {
               for(_loc3_ in param1)
               {
                  this.addMaterial(param1[_loc3_],_loc3_);
               }
            }
         }
      }
      
      public function get numMaterials() : int
      {
         return this._materialsTotal;
      }
      
      public function addMaterial(param1:MaterialObject3D, param2:String = null) : MaterialObject3D
      {
         param2 = param2 || param1.name || String(param1.id);
         this._materials[param1] = param2;
         this.materialsByName[param2] = param1;
         ++this._materialsTotal;
         return param1;
      }
      
      public function removeMaterial(param1:MaterialObject3D) : MaterialObject3D
      {
         if(this._materials[param1])
         {
            delete this.materialsByName[this._materials[param1]];
            delete this._materials[param1];
            --this._materialsTotal;
         }
         return param1;
      }
      
      public function getMaterialByName(param1:String) : MaterialObject3D
      {
         return !!this.materialsByName[param1] ? this.materialsByName[param1] : this.materialsByName["all"];
      }
      
      public function removeMaterialByName(param1:String) : MaterialObject3D
      {
         return this.removeMaterial(this.getMaterialByName(param1));
      }
      
      public function clone() : MaterialsList
      {
         var _loc2_:MaterialObject3D = null;
         var _loc1_:MaterialsList = new MaterialsList();
         for each(_loc2_ in this.materialsByName)
         {
            _loc1_.addMaterial(_loc2_.clone(),this._materials[_loc2_]);
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         var _loc2_:MaterialObject3D = null;
         var _loc1_:String = "";
         for each(_loc2_ in this.materialsByName)
         {
            _loc1_ += this._materials[_loc2_] + "\n";
         }
         return _loc1_;
      }
   }
}
