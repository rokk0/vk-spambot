# Group spambot:

>>email/phone - your login email or phone  
password      - your login password  
page          - target page, for example: http://vk.com/club19150223  
hash          - target group hash, can be found with JS command "console.log(cur.options.post_hash);" on group page, for example: 9c1c8307f8626074bf  
message       - your spam message  
count         - how many messages to send at once 1-8  
interval      - repeat time interval 1-60 minutes  

# Group discussion spambot:

>>email/phone - your login email or phone  
password      - your login password  
page          - target page, for example: http://vk.com/topic-33125365_25989232  
hash          - target group discussion hash, can be found with JS command "console.log(cur.hash);" on group discussion page, for example: bd34dc44da09a4a714  
message       - your spam message  
count         - how many messages to send at once 1-8  
interval      - repeat time interval 1-60 minutes  

# Bot configuration (bot_cfg):

>>user_agent_alias = 'Linux Mozilla'  
login_page         = 'http://vk.com'  

# Mechanize user_agent_alias:

>>'Windows IE 6'  => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)',  
'Windows IE 7'    => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)',  
'Windows Mozilla' => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.4b) Gecko/20030516 Mozilla Firebird/0.6',  
'Mac Safari'      => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; de-at) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10',  
'Mac FireFox'     => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6',  
'Mac Mozilla'     => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.4a) Gecko/20030401',  
'Linux Mozilla'   => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624',  
'Linux Firefox'   => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.1) Gecko/20100122 firefox/3.6.1',  
'Linux Konqueror' => 'Mozilla/5.0 (compatible; Konqueror/3; Linux)',  
'iPhone'          => 'Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3',  
'Mechanize'       => "WWW-Mechanize/#{VERSION} (http://rubyforge.org/projects/mechanize/)"  
