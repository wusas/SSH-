<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="<%=path%>/assets/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=path%>/assets/css/ie10-viewport-bug-workaround.css" rel="stylesheet">
    <link href="dashboard.css" rel="stylesheet">
    <script src="<%=path%>/assets/js/ie-emulation-modes-warning.js"></script>
<script type="text/javascript" src="<%=path %>/assets/js/jquery-1.8.3.js"></script>
	<script type="text/javascript" src="<%=path %>/assets/js/datepicker/WdatePicker.js"></script>
</head>
<body>
	<center>
		<form action="" method="post" name="f">
	
		                                    职工姓名：<select id="empId" name="empId"></select>
							商品名：<select id="goodsId" name="goodsId"></select>
							<!--  职工姓名：<input type="text" id="empId" name="empId"/>
							商品名：<input type="text" id="goodsId" name="goodsId"/>-->
							盘点时间：<input type="text" name="checkDate" id="checkDate" onclick="javascript:WdatePicker()" />
			 <input type="button" value="查询" onclick="query(1)" /> 
			 <input type="button" value="库存量" onclick="goIns()" />
		</form>
		<hr />
		<div id="showTable"></div>
		<hr />
		<span id="page_message"></span> <input type="button" value="首页"
			id="first" onclick="query(5)"> <input type="button"
			value="上一页" id="up" onclick="query(2)"> <input type="button"
			value="下一页" id="end" onclick="query(3)"> <input type="button"
			value="尾页" id="down" onclick="query(4)">
	</center>
</body>

<script type="text/javascript">
findEmp();
	function findEmp(){
		$(document).ready(function(){
				$.post("<%=path %>/user_findEmp.action",
				function (data){//data就是Action返回我们要的字符串
					var object = eval(data);
					var select = $("#empId");
					for(var i = 0;i<object.length;i++){
						select.append("<option value='"+object[i].EmpId+"'>"+object[i].EmpName+"</option>");
					}
	 			});
		});
	}
	findGoods();
	function findGoods(){
		$(document).ready(function(){
				$.post("<%=path %>/goods_findGoods.action",
				function (data){//data就是Action返回我们要的字符串
				
					var object = eval(data);
					var select = $("#goodsId");
					for(var i = 0;i<object.length;i++){
						select.append("<option value='"+object[i].GoodsId+"'>"+object[i].GoodsName+"</option>");
					}
	 			});
		});
	}



var xmlhttp;
var count = 0;//总共有多少笔数据
var page_count = 0;//总共多少页
var pagecur = 1;//当前第几页
var pagesize = 8;//固定显示8笔数据
query(1);

/*
	取得Ajax核心类的对象
*/
function createxmlhttp() {
	if (window.XMLHttpRequest) {//如果浏览器是类似于FireFox
		xmlhttp = new XMLHttpRequest();
	} else {
		xmlhttp = new ActiveXObject("Microsoft.XMLHttp");//使用的是ＩＥ的机制
	}
}
/*
	查询
*/
function query(a) {
	createxmlhttp();//取得xmlhttp对象
	var empId = f.empId.value;
	var goodsId = f.goodsId.value;
	var checkDate = f.checkDate.value;
	if(a==1){
		pagecur = 1;
	}else if(a==2){//查询上一页
		pagecur = pagecur-1;
	}else if(a==3){//查询下一页
		pagecur = pagecur+1;
	}else if(a==4){//最后一页
		pagecur = page_count;
	}else if(a==5){//首页
		pagecur = 1;
		}
		$(document).ready(function() {
			$.post("<%=path%>/checkTable_findAll.action", {
			    "checkDate" : checkDate,
				"goodsId" : goodsId,
				"empId" : empId,
				"pageCurrent":pagecur
			}, function(data) {
				document.getElementById("showTable").innerHTML = data;
				calc(); //计算总页数，控制按钮是否可用
			});
		});
		}
/*
	按钮控制
*/
function calc(){
	count = document.getElementById("count").value;
	if(count%pagesize==0){
		page_count = count/pagesize;
	}else{
		var v = count%pagesize;
		page_count = (count-v)/pagesize + 1;
	}
	if(pagecur == 1&&page_count!=1){
		document.getElementById("first").disabled = true;//按钮不可用
		document.getElementById("up").disabled = true;
		document.getElementById("end").disabled = false;
		document.getElementById("down").disabled = false;
	}else if(pagecur == page_count&&page_count!=1){
		document.getElementById("first").disabled = false;
		document.getElementById("up").disabled = false;
		document.getElementById("end").disabled = true;
		document.getElementById("down").disabled = true;
	}else if(page_count==1){
		document.getElementById("first").disabled = true;
		document.getElementById("up").disabled = true;
		document.getElementById("end").disabled = true;
		document.getElementById("down").disabled = true;
	}else if(pagecur<page_count&&pagecur>1){
		document.getElementById("first").disabled = false;
		document.getElementById("up").disabled = false;
		document.getElementById("end").disabled = false;
		document.getElementById("down").disabled = false;
	}
	document.getElementById("page_message").innerHTML="<font color='blue'>当前第"+pagecur+"页&nbsp;&nbsp;总共"+count+"笔，共"+page_count+"页</font>";
}
/*
	新增
*/
function goIns(){
	window.showModalDialog("TbvNewDetailAdd.jsp",window,"dialogHeight:500px;dialogWidth:600px;")
}
/*
	修改
*/




function goUpd(id_key){
	window.showModalDialog("<%=path%>/checkTable_findById.action?checkId="+id_key,window,"dialogHeight:500px;dialogWidth:600px;")
}

/*
	删除
*/

	
</script>
</html>
