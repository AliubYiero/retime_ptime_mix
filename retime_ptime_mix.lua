--[[
1.Yuint_retime_ptime_mix(dur_time,[pre_time],[post_time],[judge_duration])
2.快速retime
3.每个字逐渐出现，出现间隔有一套判断逻辑，规定了行的出现时间不会太长	-->[6]
4.pre_time为开始提前时间，可选择填写，默认提前200ms
5.post_time决定retime的结束时间，有两个模式
	a.不填post_time，为进场效果，每行会持续dur_time的时间，下一行的开始时间接着上一行的结束时间
	b.填retime，为行retime效果，每行结束在(line.end_time+post_time)，也就是正常的"line"模式的结束
6.judge_duration是一个范围规定，可选择填写，默认规定500ms
	a.如果(dur_time*line.kara.n <= judge_duration)即整行从第一个字出现到最后一个字结束的时间小于等于judge_duration，则行的出现间隔为dur_time
	b.如果(dur_time*line.kara.n > judge_duration)即整行从第一个字出现到最后一个字结束的时间大于judge_duration，则会计算出另一个时间间隔(pre_time+300)/line.kara.n
	  即(pre_time+300ms)/line.kara.n，(开始延长时间+300ms)除以音节总数的时间即为行的出现间隔
7.关于post_time，如果想和开始一样逐个消失，就自己计算一下，Yuint_retime_ptime_mix(50,200,syl.i*50)之类的
8.函数名如果觉得太长不方便可自行修改，即Yuint_retime_ptime_mix可以随意修改，然后调用的时候使用修改后的函数名；我个人这样定义的函数名是为了方便知道函数内容
--]]
function Yuint_retime_ptime_mix(dur_time,pre_time,post_time,judge_duration)
	pre_time = pre_time or 200									--定义pre_time
	judge_duration = judge_duration or 500						--定义judge_duration
	numb = (line.start_time - pre_time)
		if dur_time*line.kara.n <= judge_duration then			--判断judge_duration
			numa = dur_time
		elseif dur_time*line.kara.n > judge_duration then
			numa = (pre_time+300)/line.kara.n
		end
	re_start_time = numb+(syl.i-1)*numa							--start_time赋值
		if post_time == nil then								--post_time判断，并给end_time赋值
			re_end_time = numb + syl.i*numa
		elseif post_time ~= nil then
			re_end_time = line.end_time+post_time
		end
	return retime("abs",re_start_time,re_end_time)				--输出
end



--[[
1.下面是两个单独版本，即上面的6-a模式(step)，和6-b模式(abs)
--]]
function Yuint_retime_ptime_step(dur_time,pre_time,post_time)		
	pre_time = pre_time or 200
	numa = dur_time
	numb = (line.start_time - pre_time)
	re_start_time = numb+(syl.i-1)*numa
		if post_time == nil then
			re_end_time = numb + syl.i*numa
		elseif post_time ~= nil then
			re_end_time = line.end_time+post_time
		end
	return retime("abs",re_start_time,re_end_time)
end

--[[
1.根据start_duration的长度平均划分时间
--]]
function Yuint_retime_ptime_abs(start_duration,pre_time,post_time)		
	pre_time = pre_time or 200
	numa = start_duration/line.kara.n
	numb = (line.start_time - pre_time)
	re_start_time = numb+(syl.i-1)*numa
		if post_time == nil then
			re_end_time = numb + syl.i*numa
		elseif post_time ~= nil then
			re_end_time = line.end_time+post_time
		end
	return retime("abs",re_start_time,re_end_time)
end

