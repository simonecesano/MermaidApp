function Ancora() {
    this.keys = {};

    this.on = function(refs){
	Object.keys(refs).forEach(function(k, i){
	    var sel = 'a[href="#' + k +'"]';
	    var el = document.querySelectorAll(sel);
	    // console.log(sel)
	    el.forEach(function(e, i){
		e.addEventListener('click', refs[k], false)
	    })
	    // console.log('a[href="#' + e +'"]')
	})
    }
}


