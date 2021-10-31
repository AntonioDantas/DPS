function randColors() {
    return '#' + (function co(lor) {
        return (lor += [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'a', 'b', 'c', 'd', 'e', 'f'][Math.floor(Math.random() * 16)])
&& (lor.length == 6) ? lor : co(lor);
    })('');
}

function timeConverter(jsonDate) {
    //return eval(jsonDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1)"));
    var data = new Date(parseInt(jsonDate.substr(6)));
    var dia = data.getDate();
    var mes = data.getMonth();
    var ano = data.getFullYear();
    data = dia + '/' + (mes++) + '/' + ano;

    return data;
}

function parseJsonDate(jsonDateString) {
    //return new Date(parseInt(jsonDateString.replace('/Date(', '')));

    var date = new Date(parseInt(jsonDateString.substr(6)));

    return date.toLocaleString();
}
function loading() {
    $.blockUI({
        message: $('#displayBox'),
        css: {
            top: ($(window).height() - 15) / 2 + 'px',
            left: ($(window).width() - 128) / 2 + 'px',
            width: '128px'
        }
    });
}
function stoploading() {
    setTimeout($.unblockUI, 500);
}