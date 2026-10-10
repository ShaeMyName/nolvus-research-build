"""Minimal client for SkyrimNet's MCP server (SSE transport, http://127.0.0.1:8889). Test profile only; read-mostly.
Usage:
  mcp_client.py tools                      list tool names and input schemas
  mcp_client.py call <tool> '<json args>'  call one tool, print the result text
Never sends or prints API keys (none are involved)."""
import json, sys, threading, queue, urllib.request

BASE = "http://[::1]:8889"     # the MCP server binds localhost as IPv6 only


class MCP:
    def __init__(self):
        self.q = queue.Queue()
        self.endpoint = None
        self.resp = urllib.request.urlopen(urllib.request.Request(BASE + "/sse", headers={"Accept": "text/event-stream"}), timeout=120)
        threading.Thread(target=self._read, daemon=True).start()
        ev = self.q.get(timeout=30)
        assert ev[0] == "endpoint", ev
        self.endpoint = ev[1] if ev[1].startswith("http") else BASE + ev[1]
        self.n = 0
        self.request("initialize", {"protocolVersion": "2024-11-05", "capabilities": {},
                                    "clientInfo": {"name": "ieb-harness", "version": "1.0"}})
        self.notify("notifications/initialized", {})

    def _read(self):
        event, data = "message", []
        for raw in self.resp:
            line = raw.decode("utf-8", "replace").rstrip("\r\n")
            if line.startswith("event:"):
                event = line[6:].strip()
            elif line.startswith("data:"):
                data.append(line[5:].strip())
            elif line == "":
                if data:
                    self.q.put((event, "\n".join(data)))
                event, data = "message", []

    def _post(self, msg):
        req = urllib.request.Request(self.endpoint, data=json.dumps(msg).encode(), method="POST",
                                     headers={"Content-Type": "application/json"})
        urllib.request.urlopen(req, timeout=60).read()

    def notify(self, method, params):
        self._post({"jsonrpc": "2.0", "method": method, "params": params})

    def request(self, method, params, timeout=120):
        self.n += 1
        rid = self.n
        self._post({"jsonrpc": "2.0", "id": rid, "method": method, "params": params})
        while True:
            ev, data = self.q.get(timeout=timeout)
            try:
                m = json.loads(data)
            except ValueError:
                continue
            if isinstance(m, dict) and m.get("id") == rid:
                return m


def main(a):
    c = MCP()
    if a[0] == "tools":
        r = c.request("tools/list", {})
        for t in r["result"]["tools"]:
            print(t["name"], json.dumps(t.get("inputSchema", {}).get("properties", {}))[:400])
    elif a[0] == "call":
        r = c.request("tools/call", {"name": a[1], "arguments": json.loads(a[2]) if len(a) > 2 else {}})
        if "result" in r:
            for part in r["result"].get("content", []):
                print(part.get("text", part))
        else:
            print(json.dumps(r)[:3000])


if __name__ == "__main__":
    main(sys.argv[1:])
