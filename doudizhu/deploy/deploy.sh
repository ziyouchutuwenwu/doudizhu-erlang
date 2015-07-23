if [ "$1" = "make" ]; then
	rm -rf ./doudizhu;

	cd ../;
	rebar clean;
	rebar get-deps;
	rebar compile;
	rebar generate;
	cp -rf ./rel/doudizhu ./deploy;
	cd deploy;
	
	cp -rf ./conf/* ./doudizhu/releases/1/;
elif [ "$1" = "update" ]; then
		cp -rf ./conf/* ./doudizhu/releases/1/;
else
	printf "需要先修改sys.config和vm.args参数\n改完以后执行%s make重新编译，或者%s update更新配置\n" "$0" "$0";
fi