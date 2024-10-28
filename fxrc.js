globalThis.csv = (sep = ",") => x => {
    if (!Array.isArray(x) || x.length < 1 || typeof x[0] !== "object") return;

    const kx = Object.keys(x[0]);

    return kx.join(sep) + "\n" + x
        .map(obj => kx
            .map(k => typeof obj[k] === "string" && obj[k].includes("\n") ? `"${obj[k]}"` : obj[k])
            .join(sep))
        .join("\n");
}

globalThis.mdtable = x => {
    if (!Array.isArray(x) || x.length < 1 || typeof x[0] !== "object") return;

    const kx = Object.keys(x[0]);

    const EOL = "\n";
    const START = "| ";
    const SEP = " | ";
    const END = " |" + EOL;

    const header = START + kx.join(SEP) + END;
    const line = header.replace(/[^| \n]/g, "-");
    const rows = x
        .map(obj => START + kx.map(k => obj[k] || "").join(SEP) + END)
        .join("");

    return header + line + rows;
}

Object.pick = function pick(obj, keys) {
    if (typeof obj !== "object") {
        return {};
    }

    var res = {};
    if (typeof keys === 'string') {
        if (keys in obj) {
            res[keys] = obj[keys];
        }
        return res;
    }

    var len = keys.length;
    var idx = -1;

    while (++idx < len) {
        var key = keys[idx];
        if (key in obj) {
            res[key] = obj[key];
        }
    }
    return res;
};

Object.omit = function omit(obj, props, fn) {
    if (typeof obj !== "object") {
        return {};
    }

    if (typeof props === 'function') {
        fn = props;
        props = [];
    }

    if (typeof props === 'string') {
        props = [props];
    }

    var isFunction = typeof fn === 'function';
    var keys = Object.keys(obj);
    var res = {};

    for (var i = 0; i < keys.length; i++) {
        var key = keys[i];
        var val = obj[key];

        if (!props || (props.indexOf(key) === -1 && (!isFunction || fn(val, key, obj)))) {
            res[key] = val;
        }
    }
    return res;
};
