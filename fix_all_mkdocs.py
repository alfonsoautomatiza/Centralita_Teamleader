import os
import re
import io
import unicodedata

def fix_links(content):
    """Repara hipervínculos rotos de anclas (anchors) normalizando caracteres."""
    def repl(m):
        s = m.group(1)
        s = unicodedata.normalize('NFKD', s).encode('ASCII', 'ignore').decode('utf-8')
        return '](#' + s + ')'
    return re.sub(r'\]\(#-(.*?)\)', repl, content)

def fix_mermaid_chars(content):
    """Pone comillas obligatorias en etiquetas Mermaid v11+ que tengan signos como ¿ o ?"""
    def process_mermaid_safe(match):
        block = match.group(0)
        block = re.sub(r'([a-zA-Z0-9_-]+)\[([^\]"\n]*?[¿\?][^\]"\n]*?)\]', r'\1["\2"]', block)
        block = re.sub(r'([a-zA-Z0-9_-]+)\{([^}"\n]*?[¿\?][^}"\n]*?)\}', r'\1{"\2"}', block)
        return block
    return re.sub(r'```mermaid.*?```', process_mermaid_safe, content, flags=re.DOTALL)

def fix_mermaid_syntax(content):
    """Repara errores graves de sintaxis de Mermaid (pie, journey y formatos raros de gantt)."""
    # 1. Fix "pie chart Title" -> "pie title Title"
    content = re.sub(r'pie chart\s+([^\n]+)', r'pie title \1', content)
    content = re.sub(r'pie title (.*?)\n\s+title (.*?)\n', r'pie title \2\n', content)

    # 2. Fix journey missing 'section' keywords
    content = re.sub(r'(\n\s*)Semana 1(\n\s+20 llamadas)', r'\1section Semana 1\2', content)
    content = re.sub(r'(\n\s*)Mes 1(\n\s+100 llamadas)', r'\1section Mes 1\2', content)
    
    # 3. Fix journey actors with colons that crash Mermaid parser
    content = re.sub(r'(:\s*\d+\s*,\s*):material-[a-zA-Z0-9_-]+:', r'\1Agente', content)
    content = re.sub(r'(:\s*):material-[a-zA-Z0-9_-]+:', r'\1Agente', content)

    # 4. Fix gantt invalid dateFormat 'DD', 'SS', 'MM'
    # pantalla-configuracion
    content = re.sub(r'dateFormat\s+DD\n\s*axisFormat\s+%d', r'dateFormat YYYY-MM-DD\n    axisFormat %d', content)
    content = re.sub(r':a1,\s*01,\s*1d', r':a1, 2026-03-01, 1d', content)
    content = re.sub(r':a2,\s*01,\s*1d', r':a2, 2026-03-01, 1d', content)
    content = re.sub(r':a3,\s*01,\s*1d', r':a3, 2026-03-01, 1d', content)
    content = re.sub(r':a4,\s*01,\s*1M', r':a4, 2026-03-01, 1w', content)
    content = re.sub(r':b1,\s*02,\s*1d', r':b1, 2026-03-02, 1d', content)
    content = re.sub(r':b2,\s*02,\s*1d', r':b2, 2026-03-02, 1d', content)
    content = re.sub(r':b3,\s*02,\s*1d', r':b3, 2026-03-02, 1d', content)
    content = re.sub(r':c1,\s*03,\s*5d', r':c1, 2026-03-03, 5d', content)
    content = re.sub(r':c2,\s*03,\s*5d', r':c2, 2026-03-03, 5d', content)
    content = re.sub(r':c3,\s*03,\s*5d', r':c3, 2026-03-03, 5d', content)
    
    # ejemplos-dia-a-dia
    content = re.sub(r':c1,\s*04,\s*4d', r':c1, 2026-03-04, 4d', content)
    content = re.sub(r':c2,\s*04,\s*4d', r':c2, 2026-03-04, 4d', content)
    content = re.sub(r':c3,\s*04,\s*4d', r':c3, 2026-03-04, 4d', content)

    # creacion-nuevo-registros
    content = re.sub(r'dateFormat\s+SS\n\s*axisFormat\s+%s s', r'dateFormat X\n    axisFormat %S', content)
    content = re.sub(r':a1,\s*00,\s*300', r':a1, 0, 300s', content)
    content = re.sub(r':a2,\s*00,\s*180', r':a2, 0, 180s', content)
    content = re.sub(r':a3,\s*00,\s*120', r':a3, 0, 120s', content)
    content = re.sub(r':a4,\s*00,\s*600', r':a4, 0, 600s', content)
    content = re.sub(r':b1,\s*00,\s*30', r':b1, 0, 30s', content)
    content = re.sub(r':b2,\s*00,\s*90', r':b2, 0, 90s', content)
    content = re.sub(r':b3,\s*00,\s*120', r':b3, 0, 120s', content)
    
    # link-descarga
    content = re.sub(r'dateFormat\s+MM\n\s*axisFormat\s+%M', r'dateFormat YYYY-MM-DD\n    axisFormat %d', content)

    return content

def process_all():
    print("==============================================")
    print("Iniciando reparación integral de MkDocs...")
    print("==============================================")
    count = 0
    for root, dirs, files in os.walk('docs'):
        for file in files:
            if file.endswith('.md'):
                path = os.path.join(root, file)
                try:
                    with io.open(path, 'r', encoding='utf-8') as f:
                        original = f.read()
                    
                    content = original
                    content = fix_links(content)
                    content = fix_mermaid_chars(content)
                    content = fix_mermaid_syntax(content)
                    
                    if content != original:
                        with io.open(path, 'w', encoding='utf-8') as f:
                            f.write(content)
                        print(f"✅ Reparado: {path}")
                        count += 1
                except Exception as e:
                    print(f"❌ Error en {path}: {str(e)}")
                    
    print("==============================================")
    print(f"✅ Proceso finalizado. {count} archivos actualizados.")
    print("==============================================")

if __name__ == "__main__":
    process_all()
