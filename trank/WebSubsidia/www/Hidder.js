function clickIt(prefix)  
  { if (prefix==null) {
    prefix='adr';
  }
  var searchbox=document.getElementById('searchbox');
  subSt=searchbox.value;
  subSt=subSt.toUpperCase();
  // if (subSt!=''&&subSt.length<3) {return};
  for (var i=0; i<AdrCnt; i++) {
    s = prefix+i;
    // document.body.innerText = s;
    var el=document.getElementById(s);
    if (el==null) continue;
    st=el.innerText;
    st=st.toUpperCase();
    p=st.indexOf(subSt);
    if (p!=-1||subSt=='') {
      el.style.display="inline";
      // el.innerText=el.innerText+p;
    } else {
      el.style.display="none";
    }
  }
}

function SwithHelp(HelpId)
  { if (HelpId==null || HelpId=='') {
    return;
  }
  var HelpBox=document.getElementById(HelpId);
  visible=HelpBox.style.display;
  if (visible=='none') {
    HelpBox.style.display="block";
  } else {
    HelpBox.style.display="none";
  }
}

function SetFocus(s)
{
  if (s==null || s==''){
    return;
  }
  Element=document.getElementById(s);
  if (Element==null) return;
  Element.focus();
  Element.select();
  return Element.tagName;
}
