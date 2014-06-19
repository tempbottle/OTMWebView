//
// OTMWebView.js
//
// Copyright (c) 2014 Ryan Coffman
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

function triggerRequest(command) {

	var iframe = document.createElement("IFRAME");
	iframe.setAttribute("src", "otmwebview://" + command);
	document.body.appendChild(iframe);
	iframe.parentNode.removeChild(iframe);
	iframe = null;
}

var target = document.querySelector('head > title');
var observer = new window.WebKitMutationObserver(function(mutations) {
	mutations.forEach(function(mutation) {
		triggerRequest("setDocumentTitle/" + mutation.target.textContent);
	});
});
observer.observe(target, {
	subtree: true,
	characterData: true,
	childList: true
});

if (document.readyState == "interactive") {
	document.onreadystatechange = function() {

		triggerRequest("onReadyStateChange/" + document.readyState)
	}
}
