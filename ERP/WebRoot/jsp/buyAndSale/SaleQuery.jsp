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
	<script type="text/javascript" src="<%=path %>/assets/js/jquery-1.7.2.js"></script>
	<script type="text/javascript" src="<%=path %>/assets/js/datepicker/WdatePicker.js"></script>
</head>
<body>
	<center>
		<form action="" method="post" name="f">
			<table>
				<tr>
					<td>销售单名称：<input type="text" name="saleName" id="saleName" /></td>
					<td>
					处理职工: 
						<select name="empId" id="empId">
							<option selected="selected" value="-99">所有</option>
						</select>
					</td>
					<td>
					客户: 
						<select name="clientId" id="clientId">
							<option selected="selected" value="-99">所有</option>
						</select>
					</td>
					<td>
					当前状态：
						 <select name="saleState">
							<option value="-99" selected="selected">所有</option>
							<option value="1">只拟定订单</option>
							<option value="2">已出库</option>
							<option value="3">已结算</option>
						</select> 
					</td>
					<td>
					是否删除： 
						<select name="saleDel">
							<option value="0" selected="selected">否</option>
							<option value="1">是</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="3">
					&nbsp;&nbsp;&nbsp;&nbsp;起止时间：
						<input type="text" name="startDate" onclick="javascript:WdatePicker()" />~
						<input type="text" name="endDate" onclick="javascript:WdatePicker()" />
					</td>
					<td>
						<input type="button" value="查询" onclick="query(1)" /> 
						<input type="button" value="新增" onclick="goIns()" />
					</td>
				</tr>
			</table>
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
var xmlhttp;
var count = 0;//总共有多少笔数据
var page_count = 0;//总共多少页
var pagecur = 1;//当前第几页
var pagesize = 8;//固定显示8笔数据

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
getClient();
	function getClient(){
		$(document).ready(function() {
			$.post("<%=path%>/sale_findClient.action", {}, function(data) {
			 	var jsonA = eval(data);
				 $.each(jsonA, function (i, item) {  
				 	if(0 == item.clientDel){
				 		$("#clientId").append("<option value='"+item.clientId+"'>"+item.clientName+"</option>");
				 	}
       			 }); 
			});
		});
	}
query(1);
function query(a) {
	createxmlhttp();//取得xmlhttp对象
	var saleName = f.saleName.value;
	var clientId = f.clientId.value;
	var empId = f.empId.value;
	var startDate = f.startDate.value;
	var endDate = f.endDate.value;
	var saleState = f.saleState.value;
	var saleDel = f.saleDel.value;
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
			$.post("<%=path%>/sale_findBySome.action", {
				"saleName":saleName,
				"clientId" : clientId,
				"empId" : empId,
				"startDate" : startDate,
				"endDate" : endDate,
				"saleState" : saleState,
				"saleDel" : saleDel,
				"pagecur" : pagecur
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
	window.showModalDialog("<%=path%>/jsp/buyAndSale/SaleInsert.jsp",window,"dialogHeight:800px;dialogWidth:600px;")
}
/*
	修改
*/
function goShow(id_key){
	window.showModalDialog("<%=path%>/sale_findById.action?saleId="+id_key,window,"dialogHeight:500px;dialogWidth:600px;")
	}
	/*
		删除
	*/
	function goDel(id_key) {
		if (confirm("确认删除？")) {
			$(document).ready(function() {
				$.post("<%=path%>/sale_doDel.action", {
					"saleId" : id_key
				}, function(data) {
					if (data== "true") {
						alert("删除失败");
					} else {
						alert("删除成功");
						query(0);
					}
				});
			});
		}
	}
</script>
</html>
