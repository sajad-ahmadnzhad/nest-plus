<h1 align="center">🌟 Nest-Plus 🌟</h1>
<p align="center">🚀 Boost Your NestJS Development with Ease!</p>

<p align="center">
  <img src="https://img.shields.io/badge/bash-powered-blue?style=flat-square" alt="Powered by Bash" />
  <img src="https://img.shields.io/badge/nestjs-framework-red?style=flat-square" alt="NestJS Framework" />
  <img src="https://img.shields.io/github/license/your-repo/nest-plus?style=flat-square" alt="License" />
</p>

<hr />

<h2>🌟 Overview</h2>
<p><strong>Nest-Plus</strong> is a powerful Bash script that simplifies the process of creating NestJS projects. It automates repetitive tasks, sets up a modular structure, and integrates essential features to get you started in no time!</p>

<hr />

<h2>🎯 Key Features</h2>
<ul>
  <li><strong>Interactive Setup:</strong> Guides you through creating a NestJS project using <code>fzf</code> for a smooth user experience.</li>
  <li><strong>Modular Structure:</strong> Automatically creates a clean and well-organized folder structure:
    <ul>
      <li><code>common</code>: Includes pipes, filters, guards, middlewares, enums, decorators, and utilities.</li>
      <li><code>configs</code>: Centralized configuration management.</li>
      <li><code>modules</code>: Modularized application logic, including the <code>app</code> module.</li>
    </ul>
  </li>
  <li><strong>Database Integration:</strong> Supports popular ORMs/ODMs:
    <ul>
      <li>TypeORM</li>
      <li>MikroORM</li>
      <li>Mongoose</li>
      <li>No Database</li>
    </ul>
  </li>
  <li><strong>Additional Features:</strong> Optionally integrates:
    <ul>
      <li>Redis or Redis Cache Manager</li>
      <li>Swagger for API documentation</li>
    </ul>
  </li>
</ul>

<hr />

<h2>📦 Installation</h2>
<pre><code>git clone https://github.com/your-repo/nest-plus.git
cd nest-plus
chmod +x nest-plus.sh
./nest-plus.sh
</code></pre>

<hr />

<h2>⚙️ Usage</h2>
<ol>
  <li>Run the script and follow the interactive prompts.</li>
  <li>Select your preferred ORM/ODM, database, and optional features (e.g., Swagger, Redis).</li>
  <li>Enjoy a fully set up NestJS project with a clean and modular structure!</li>
</ol>

<hr />

<h2>📁 Folder Structure</h2>
<p>The script generates a well-organized structure for your NestJS project:</p>
<pre><code>
src/
├── common/
│   ├── pipes/
│   ├── filters/
│   ├── guards/
│   ├── middlewares/
│   ├── enums/
│   ├── decorators/
│   ├── utils/
├── configs/
├── modules/
│   ├── app/
│       ├── app.module.ts
.env
.env.example
</code></pre>

<hr />

<h2>✨ Contributions</h2>
<p>We welcome contributions! Feel free to open issues, submit pull requests, or suggest new features.</p>

<hr />

<h2>📄 License</h2>
<p>This project is licensed under the <a href="LICENSE">MIT License</a>.</p>

<hr />

<h2>💬 Feedback</h2>
<p>If you have any questions or feedback, feel free to reach out or open an issue in the repository.</p>
