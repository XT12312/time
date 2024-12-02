

const express = require('express');
const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json())
const mysql = require('mysql');

const hm = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '123456',
    database: 'time'
});
function create(username, password, email) {
    hm.query('INSERT INTO user (username, password, email) VALUES (?, ?, ?)', [username, password, email] )
}
hm.connect();
// 注册账号
app.post("/publish", async (req, res) => {
    try {
        const { username, password, email} = req.body;
        create(username, password, email);
        res.send("success")
    } catch (error) {
        res.send(error, "error")
    }
})

//修改账号密码
app.post("/upd", async (req, res) => {
    try {
        const { username, password,email } = req.body;
        hm.query('SELECT * FROM user WHERE username = ?', [username],(error, results) =>{
            if (results.length !== 1){
                res.send({
                    status: 1,
                    message: "账号不存在",
                });
            }else {
                res.send({
                    status: 2,
                    message: "修改成功",
                });
                hm.query('UPDATE user SET password=?,email=? where username=?', [password,email,username])
            }
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
// 账号登录
app.get("/find/:username/:password", async (req, res) => {
    try {
        const username = req.params.username;
        const password = req.params.password;
        hm.query('SELECT * FROM user WHERE username = ? AND password = ?', [username, password],(err, results) =>{
            if (results.length !== 1){
                res.send({
                    status: 1,
                    message: "登录失败，请稍后再试",
                });
            }else {
                res.send({
                    status: 2,
                    message: "登录成功",
                    loginAchieve:true,
                    yonghu:results[0]['username'],
                    mima:results[0]['password'],
                });
            }
        })
    } catch (error) {
        res.status(500).json({ message: "服务器内部错误" });
    }
});
// 查询账号
app.post("/xc", async (req, res) => {
    try {
        const { username } = req.body;
        hm.query('SELECT * FROM user WHERE username = ?', [username],(error, results) =>{
            res.send({
                mima:results[0]['password'],
                email:results[0]['email'],
            });
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
//收藏
app.post("/like", async (req, res) => {
    try {
        const { title,photo, jieshao} = req.body;
        hm.query('INSERT INTO Like1 (title,photo, jieshao) VALUES (?,?, ?)', [title, photo, jieshao] )
        res.send("success")
        // console.log(results)
    } catch (error) {
        res.send(error, "error")
    }
})
//取消收藏
app.post("/unlike", async (req, res) => {
    try {
        const { title} = req.body;
        hm.query('DELETE FROM Like1 WHERE title=(?)', [title] )
        res.send("success")
        // console.log(results)
    } catch (error) {
        res.send(error, "error")
    }
})
//查看我的收藏
app.post("/Mylike", async (req, res) => {
    try {
        hm.query('SELECT * FROM Like1',(error, results) =>{
            res.send({
                shoucang:results
            });
        });

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
//跳转详情
app.post("/detail", async (req, res) => {
    try {
        const { title} = req.body;
        hm.query('SELECT * FROM Like1 WHERE title = ?', [title],(error, results) =>{
            res.send({
                tupian:results[0]['photo'],
                neirong:results[0]['jieshao'],
            });
        });

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
app.listen(3000, () => {
    console.log('server running')
})