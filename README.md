# 河北省机关事业单位养老保险待遇资格认证查询系统

## 📌 项目简介

本工具为河北省机关事业单位养老保险待遇资格认证状态专用查询系统，基于Python 3.10+开发，采用浏览器自动化技术实现人社厅官网的认证状态查询功能。

## 🚀 核心功能

- **自动化查询**  
  ▸ 自动登录河北省人社厅官网  
  ▸ 智能解析认证状态信息  
  ▸ 支持批量处理Excel数据

- **企业级特性**  
  ✅ 断点续查功能  
  ✅ 代理服务器支持（HTTP/Socks5）  
  ✅ 浏览器指纹混淆  
  ✅ 操作日志审计追踪  
  ✅ 结果文件数字水印

## 📦 安装部署

### 环境要求

- Windows 10+/CentOS 7+  
- Python 3.10+  
- Chromium浏览器内核

### 完整安装步骤

```powershell
# 创建虚拟环境（推荐）
python -m venv .venv
.\.venv\Scripts\activate

# 安装依赖库
pip install -r requirements.txt

# 初始化Playwright浏览器环境
python -m playwright install chromium
python -m playwright install-deps chromium
```

## 🛠 配置说明

编辑 `config/config.ini` 进行个性化配置：

```ini
[Browser]
timeout = 30000       # 浏览器超时时间（毫秒）
user_agent = Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36...

[Proxy]
enable = true         # 启用代理服务器
proxy_type = http     # 代理类型（http/socks5）
server = 10.10.1.100  # 代理服务器IP
port = 8080           # 代理端口
```

## 🖥 使用指南

### 典型运行示例

```bash
# 基本模式（显示进度条）
python searchinfo.py "C:\参保人员名单.xlsx"

# 静默模式（无终端输出）
python searchinfo.py --silent "C:\参保人员名单.xlsx"

# 调试模式（显示详细日志）
python searchinfo.py --debug "C:\参保人员名单.xlsx"
```

### 数据文件要求

| 列号 | 字段     | 要求                |
| ---- | -------- | ------------------- |
| C列  | 姓名     | 中文姓名，2-4个汉字 |
| E列  | 身份证号 | 18位有效身份证号码  |

## ⚠️ 注意事项

1. **网络配置要求**

   - 必须开放至 `he.12333.gov.cn` 的443端口
   - 建议配置固定IP白名单

2. **浏览器兼容性**

   ```bash
   # 若遇到浏览器启动问题，尝试重置环境
   python -m playwright uninstall chromium
   python -m playwright install chromium
   ```

3. **日志查看**

   ```bash
   # 日志文件路径
   tail -f logs/cert_check_$(date +%Y%m%d).log
   ```

## 📞 技术支持

| 服务类型     | 联系方式                         |
| ------------ | -------------------------------- |
| 紧急技术支持 | 电话：0312-1234567（24小时）     |
| 常规问题咨询 | 邮箱：kqfw-tzy@petrochina.com.cn |
| 系统升级申请 | 填写《系统维护申请表》OA流程     |

---

**中国石油天然气股份有限公司河北分公司** ⋅ ©2025 保留所有权利  
*根据《中国石油信息化管理规定》要求，禁止任何形式的系统外传*
