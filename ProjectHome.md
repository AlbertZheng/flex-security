flex UI组件权限控制框架

# 一.快速开始 #

1) 下载并添加flex\_security.swf在你的flex libs中

2) 启动权限控制
```
//启动权限控制,permissions为用户拥有的权限字符串列表
SecurityControler.start(permissions,'visible');
```
3) 通过增加styleName=security(permission,controlBy)为你的按钮增加权限控制
```
<mx:Button label="new user" styleName="security(user_new)" />
<mx:Button label="update user" styleName="security(user_update)"/>
```

如上，如果用户拥有这两个权限(permissions):user\_new,user\_update,则可以见到这两个按钮,然后执行相关操作

# 二.ActionScript代码的权限控制 #
```
if(SecurityControler.isPermitted('blog_delete')) 
{
    //execute delete blog action
}
```

# 三.在线demo #
  * [helloworld\_by\_styleName](http://flex-security.googlecode.com/svn/trunk/flex_security_demo/bin-debug/helloworld_by_styleName.swf) 示例使用styleName添加权限保护
  * [helloworld\_by\_interface](http://flex-security.googlecode.com/svn/trunk/flex_security_demo/bin-debug/helloworld_by_interface.swf) 示例使用实现接口来添加权限保护
  * [helloworld\_by\_annotation](http://flex-security.googlecode.com/svn/trunk/flex_security_demo/bin-debug/helloworld_by_annotation.swf) 示例使用annotation:[Projected](Projected.md)来添加权限保护
  * [helloworld\_by\_manual](http://flex-security.googlecode.com/svn/trunk/flex_security_demo/bin-debug/helloworld_by_manual.swf) 示例使用手工的方式添加权限保护
  * [demo源代码地址](http://flex-security.googlecode.com/svn/trunk/flex_security_demo/src/)
# 四.详细描述 #
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

**`SecurityControler类,包含全部的主要权限控制操作:`**
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

