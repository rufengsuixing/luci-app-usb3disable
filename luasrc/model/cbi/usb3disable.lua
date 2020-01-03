require("luci.sys")
local m,s,o
m = Map("usb3disable", "usb3disable")
s = m:section(TypedSection, "usb3disable")
s.anonymous=true
s.addremove=false

o=s:option(Button,"disabled",translate("disable now"))
o.optional = true
o.inputtitle=translate("Disable")
o.write=function()
	luci.sys.exec("cat /etc/modules.d/$(ls /etc/modules.d | grep usb3) | sed -n '1!G;h;$p' | xargs rmmod")
	luci.http.redirect(luci.dispatcher.build_url("admin","system","usb3disable"))
end

if luci.sys.call("ls /etc/modules-boot.d | grep usb3")==0 then
	o=s:option(Button,"disabledstartup",translate("disable on boot"))
	o.optional = true
	o.inputtitle=translate("Disable")
	o.write=function()
		luci.sys.exec("rm /etc/modules-boot.d/*-usb3")
		luci.http.redirect(luci.dispatcher.build_url("admin","system","usb3disable"))
	end
else
	o=s:option(Button,"enabledstartup",translate("enable on boot"))
	o.optional = true
	o.inputtitle=translate("Enable")
	o.write=function()
		luci.sys.exec("ln -s /etc/modules.d/*usb3 /etc/modules-boot.d/")
		luci.http.redirect(luci.dispatcher.build_url("admin","system","usb3disable"))
	end
end
return m