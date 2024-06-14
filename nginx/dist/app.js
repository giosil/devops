var APP;
(function (APP) {
    var Main = /** @class */ (function () {
        function Main(msg) {
            this.msg = msg;
        }
        Main.prototype.render = function (id) {
            var e = document.getElementById(id);
            if (e)
                e.innerHTML = '<p><strong>' + this.msg + '</strong></p>';
        };
        return Main;
    }());
    APP.Main = Main;
})(APP || (APP = {}));
