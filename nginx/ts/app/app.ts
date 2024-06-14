namespace APP {

    export class Main  {
        msg: string;

        constructor(msg: string) {
            this.msg = msg;
        }

        render(id: string) {
            let e = document.getElementById(id);
            if(e) e.innerHTML = '<p><strong>' + this.msg + '</strong></p>';
        }
    }

}
