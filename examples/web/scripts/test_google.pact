NewUserAgent
GoTo			http://www.google.com/
CheckStatus		200
CheckTitleIs	Google

SetField		q	PerlActor
Submit

CheckStatus		200
CheckTitleIs	"PerlActor - Google Search"
