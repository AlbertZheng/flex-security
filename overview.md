# 详细描述 #
**styleName: security(permission,controlBy)**
  * permission: 权限标识,用户拥有该权限，才可以执行相关操作。可选参数，如果为空，则会取该comp.id作为permission
  * controlBy: 按什么方式来控制权限，有(visible,enabled,includeInLayout,remove)。可选参数，如果为空，则取SecurityControler.start(perms,defaultControlBy)中的defaultControlBy的值,默认是visible

**controlBy**

按什么方式来控制权限。
  * visible : 可见性,有权限为true,没有权限为false
  * enabled : 激活状态，有权限为true,没有权限为false
  * includeInLayout : 有权限为true,没有权限为false
  * remove : 使用removeChild()将对象从parent中remove掉，有权限不remove,没有权限则remove
  * all : 包含前面所讲的:visible,enabled,includeInLayout,但不包含remove

**ActionScript代码的权限控制**
```
if(SecurityControler.isPermitted('blog_delete')) 
{
    //execute delete blog action
}
```

**SecurityControler类,包含全部的主要权限控制操作:**
```
/**
 * 启动权限控制
 * permissions: 字符串列表,为拥有的权限
 * default_control_by: 按那种方式控制权限,可选值: visible,enabled,remove,includeInLayout
 */
public static function start(permissions:ArrayCollection = null,default_control_by : String = "visible"):void 

//停止权限控制 
public static function stop():void 

// 移除所有权限
public static function removeAllPerms():void
/**
 * 更新拥有的权限
 * perms: 字符串列表，用户拥有的权限
 */		
public static function updatePerms(perms:ArrayCollection):void 

//增加一条权限	
public static function addPerm(permName:String):void

// 减少一条权限
public static function removePerm(permName:String):void

// 判断是否拥有权限
//示例: if(SecurityControler.isPermitted('blog_delete')) { do some thing} 
public static function isPermitted(perm:String):boolean
```