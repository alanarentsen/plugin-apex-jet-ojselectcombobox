# plugin-apex-jet-ojselectcombobox

The following version combinations are tested and working:

|APEX version|JET version|
|--|--|
|5.1|2.0.2|
|5.1|4.2.0*|
|18.1|4.2.0|
|18.2|4.2.0|

_* not supported by Oracle. Use with caution if you use another JET version than the one shipped with APEX.

## Settings

|||
|--|--|
|**Component Type**| _ojSelect_ or _ojCombobox_|
|**Placeholder**| [_type any text you want_]|
|**Multi-select**| _Yes_ or _No_|
|||

## SQL Query

Enter the SQL query definition to populate this list of values. Generally list of value queries are of the form:

    select [displayValue]
          ,[returnValue]
          ,[groupValue]
          ,[iconOrImageValue]
      from ...
     order by ...

Each column selected must have a unique name or alias. Oracle recommends using an alias on any column that includes an SQL expression.

### Examples

Display department name, set department number

    select dname  as d
          ,deptno as r
      from dept
     order by 1

Display employee name, set employee number grouped by department number

    select ename  as d
          ,empno  as r
          ,deptno as g
      from emp
     order by 3, 1

Display employee name with thumbnail, set employee number grouped by department number

    select ename            as d
          ,empno            as r
          ,deptno           as g
          ,[urlToThumbnail] as i
      from emp
     order by 3, 1
urlToThumbnail must contain a forward slash '_/_' in order to detect the URL.

Display employee name with icon, set employee number grouped by department number

    select ename       as d
          ,empno       as r
          ,deptno      as g
          ,[iconClass] as i
      from emp
     order by 3, 1

IconClass can be a font APEX or fontAwesome iconClass like '_fa fa-apple_'.
IconClass can also use APEX color and status modifiers like '_u-hot-text_'.

#### Additional Information

-   Type: SQL Query
-   Supported Bind Variables: Application, Page Items and System Variables
-   Minimum Columns: 2
-   Maximum Columns: 4

## JavaScript
After the plugin is initialized, the plugin can be accessed in JavaScript via the **widget.ojet.ojselectcombobox** object.

 - **create** : Initialization function for the plugin. You should not need this.
 - **info** : Information about the plugin.
 - **items** : List with all the apex items the plugin created. Via this object the list content can be dynamically changed.

The value of the item can be manupilated via the usual APEX item interface. It can also be enabled or disabled via this interface.
