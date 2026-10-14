"""Valida recursos y conexiones; no sustituye la compilación de UIKit en Xcode."""
from pathlib import Path
import json, plistlib, xml.etree.ElementTree as ET
from PIL import Image
root = Path(__file__).resolve().parent
for folder in sorted(root.glob('0*_*')):
    app = next(p for p in folder.iterdir() if p.is_dir() and not p.name.endswith('.xcodeproj'))
    pbx = (folder / (app.name + '.xcodeproj') / 'project.pbxproj').read_text()
    plistlib.loads((app / 'Info.plist').read_bytes())
    for p in app.glob('*.swift'):
        assert f'path = {p.name};' in pbx, p
    for p in app.glob('*.storyboard'):
        tree = ET.parse(p)
        ids = {e.attrib['id'] for e in tree.iter() if 'id' in e.attrib}
        for e in tree.iter():
            if e.tag in ('outlet', 'segue'):
                assert e.attrib['destination'] in ids, e.attrib
            for key in ('firstItem', 'secondItem'):
                if key in e.attrib:
                    assert e.attrib[key] in ids, e.attrib
    main = ET.parse(app / 'Main.storyboard')
    assert len(main.findall('.//tableViewCell')) == 1
    cell = main.find('.//tableViewCell')
    assert cell.attrib['reuseIdentifier'] == 'celda'
    assert {'dataSource','delegate','tableView'} <= {x.attrib['property'] for x in main.findall('.//outlet')}
    for p in app.rglob('Contents.json'):
        data = json.loads(p.read_text())
        for img in data.get('images', []):
            if 'filename' in img:
                with Image.open(p.parent / img['filename']) as im: im.verify()
    ET.parse(folder / (app.name + '.xcodeproj') / 'xcshareddata/xcschemes' / (app.name + '.xcscheme'))
    print(f'OK: {app.name} — XML, plist, recursos y membresía')
print('Pendiente: compilar y ejecutar con Xcode en macOS.')
