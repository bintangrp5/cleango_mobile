import os
import re

def replace_snackbars(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart') and file != 'snackbar_util.dart':
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                if 'Get.snackbar(' in content:
                    # We will replace Get.snackbar(...) with AppSnackbar.show(...)
                    # Since parsing dart with regex is hard, let's do a char-by-char state machine.
                    
                    new_content = ""
                    i = 0
                    changed = False
                    needs_import = False
                    
                    while i < len(content):
                        if content[i:i+13] == 'Get.snackbar(':
                            changed = True
                            needs_import = True
                            
                            # Find the matching closing parenthesis
                            open_parens = 1
                            j = i + 13
                            in_string = False
                            string_char = ''
                            
                            args_str = ""
                            while j < len(content) and open_parens > 0:
                                char = content[j]
                                if char in ("'", '"'):
                                    if not in_string:
                                        in_string = True
                                        string_char = char
                                    elif string_char == char and content[j-1] != '\\':
                                        in_string = False
                                        
                                if not in_string:
                                    if char == '(':
                                        open_parens += 1
                                    elif char == ')':
                                        open_parens -= 1
                                        
                                if open_parens > 0:
                                    args_str += char
                                j += 1
                                
                            # Now args_str contains the arguments.
                            # The first two arguments are title and message. They are separated by commas, but commas can be inside strings or nested parens.
                            
                            title = ""
                            message = ""
                            
                            # Simple split by comma that respects strings and parens
                            args = []
                            current_arg = ""
                            open_p = 0
                            in_str = False
                            str_c = ''
                            
                            for char in args_str:
                                if char in ("'", '"'):
                                    if not in_str:
                                        in_str = True
                                        str_c = char
                                    elif str_c == char and current_arg[-1:] != '\\':
                                        in_str = False
                                
                                if not in_str:
                                    if char == '(':
                                        open_p += 1
                                    elif char == ')':
                                        open_p -= 1
                                    elif char == ',' and open_p == 0:
                                        args.append(current_arg.strip())
                                        current_arg = ""
                                        continue
                                        
                                current_arg += char
                                
                            if current_arg:
                                args.append(current_arg.strip())
                                
                            if len(args) >= 2:
                                t = args[0]
                                m = args[1]
                                new_content += f"AppSnackbar.show({t}, {m})"
                            else:
                                new_content += content[i:j] # Fallback if parsing fails
                                
                            i = j
                        else:
                            new_content += content[i]
                            i += 1
                            
                    if changed:
                        # Add import if missing
                        # Calculate relative path to util
                        # util is at lib/app/utils/snackbar_util.dart
                        # file is at root + file
                        rel_path = os.path.relpath('lib/app/utils/snackbar_util.dart', root)
                        rel_path = rel_path.replace('\\', '/')
                        
                        if 'snackbar_util.dart' not in new_content:
                            imports = f"import '{rel_path}';\n"
                            
                            # Insert after the last import
                            lines = new_content.split('\n')
                            last_import = 0
                            for idx, line in enumerate(lines):
                                if line.startswith('import '):
                                    last_import = idx
                            
                            lines.insert(last_import + 1, imports.strip())
                            new_content = '\n'.join(lines)
                            
                        with open(filepath, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        print(f"Updated {filepath}")

replace_snackbars('lib')
