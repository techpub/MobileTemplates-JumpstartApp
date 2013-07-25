function navigate(url, tran, rev) {
    var r = rev == undefined ? false : rev;
    $.mobile.changePage(url, { transition: tran, reverse: r, allowSamePageTransition: true });
}