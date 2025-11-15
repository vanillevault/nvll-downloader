const axios = require('axios');
const UserAgent = require('user-agents');

class YTDown {
    constructor() {
        this.ua = new UserAgent();
        this.ref = 'https://ytdown.to/es2/';
        this.ct = 'application/x-www-form-urlencoded; charset=UTF-8';
        this.origin = 'https://ytdown.to';
    }

    generarIP() {
        return `${Math.floor(Math.random() * 256)}.${Math.floor(Math.random() * 256)}.${Math.floor(Math.random() * 256)}.${Math.floor(Math.random() * 256)}`;
    }

    async req(url, dat, acc = '*/*') {
        try {
            const headers = {
                'Accept': acc,
                'Content-Type': this.ct,
                'Origin': this.origin,
                'Referer': this.ref,
                'User-Agent': this.ua.toString(),
                'X-Forwarded-For': this.generarIP(),
                'X-Requested-With': 'XMLHttpRequest'
            };

            const res = await axios({
                method: 'POST',
                url: url,
                headers: headers,
                data: dat,
                decompress: true,
                timeout: 30000
            });
            return res.data;
        } catch (err) {
            if (err.response) {
                throw new Error(`HTTP ${err.response.status}: ${err.response.statusText}`);
            } else if (err.request) {
                throw new Error('No response from server');
            } else {
                throw new Error(`Request error: ${err.message}`);
            }
        }
    }

    async chk() {
        const res = await this.req(
            'https://ytdown.to/cooldown.php',
            'action=check',
            'application/json, text/javascript, */*; q=0.01'
        );
        return res.can_download === true;
    }

    async getInfo(url) {
        const enc = encodeURIComponent(url);
        return await this.req(
            'https://ytdown.to/proxy.php',
            `url=${enc}`,
            '*/*'
        );
    }

    async rec() {
        const res = await this.req(
            'https://ytdown.to/cooldown.php',
            'action=record',
            'application/json, text/javascript, */*; q=0.01'
        );
        return res.success === true;
    }

    async startDL(dlUrl) {
        const enc = encodeURIComponent(dlUrl);
        return await this.req(
            'https://ytdown.to/proxy.php',
            `url=${enc}`,
            '*/*'
        );
    }

    async waitForDL(dlUrl, timeout = 60000, interval = 2000) {
        const start = Date.now();
        while (Date.now() - start < timeout) {
            const res = await this.startDL(dlUrl);
            if (res.api && res.api.fileUrl) return res.api.fileUrl;
            await new Promise(r => setTimeout(r, interval));
        }
        return dlUrl;
    }

    getMed(info, fmt) {
        if (!info.api || !info.api.mediaItems) return [];
        const fup = fmt.toUpperCase();
        if (fup === 'MP3') {
            return info.api.mediaItems
                .filter(it => it.type === 'Audio')
                .map(aud => ({
                    t: aud.type,
                    n: aud.name,
                    id: aud.mediaId,
                    url: aud.mediaUrl,
                    thumb: aud.mediaThumbnail,
                    q: aud.mediaQuality,
                    dur: aud.mediaDuration,
                    ext: aud.mediaExtension,
                    sz: aud.mediaFileSize
                }));
        } else if (fup === 'MP4') {
            return info.api.mediaItems
                .filter(it => it.type === 'Video')
                .map(vid => ({
                    t: vid.type,
                    n: vid.name,
                    id: vid.mediaId,
                    url: vid.mediaUrl,
                    thumb: vid.mediaThumbnail,
                    res: vid.mediaRes,
                    q: vid.mediaQuality,
                    dur: vid.mediaDuration,
                    ext: vid.mediaExtension,
                    sz: vid.mediaFileSize
                }));
        }
        return info.api.mediaItems;
    }

    getBest(med, fmt) {
        if (!med || med.length === 0) return null;
        const fup = fmt.toUpperCase();
        if (fup === 'MP3') {
            return med
                .filter(it => it.q)
                .sort((a, b) => (parseInt(b.q) || 0) - (parseInt(a.q) || 0))[0] || med[0];
        } else if (fup === 'MP4') {
            return med
                .filter(it => it.res)
                .sort((a, b) => (parseInt(b.res.split('x')[0]) || 0) - (parseInt(a.res.split('x')[0]) || 0))[0] || med[0];
        }
        return med[0];
    }

    async ytdownV2(ytUrl, fmt = 'MP3') {
        try {
            if (!(await this.chk())) {
                throw new Error("Service not available");
            }

            const info = await this.getInfo(ytUrl);
            if (info.api?.status === 'ERROR') {
                throw new Error(`Service error: ${info.api.message}`);
            }

            const med = this.getMed(info, fmt);
            if (med.length === 0) {
                throw new Error(`No ${fmt.toUpperCase()} options available`);
            }

            const best = this.getBest(med, fmt);
            if (!best) {
                throw new Error("No suitable media found");
            }

            await this.rec();

            const directUrl = await this.waitForDL(best.url);
            return directUrl;

        } catch (err) {
            throw new Error(err.message);
        }
    }
}

const ytdownV2 = async (ytUrl, fmt = 'MP3') => {
    const yt = new YTDown();
    return await yt.ytdownV2(ytUrl, fmt);
};

const [url, format] = process.argv.slice(2);
if (!url) {
    console.error('Error: URL is required');
    process.exit(1);
}

ytdownV2(url, format || 'MP3')
    .then(downloadUrl => {
        console.log(downloadUrl);
    })
    .catch(error => {
        console.error('Error:', error.message);
        process.exit(1);
    });
